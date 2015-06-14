#!/usr/bin/perl
use strict;
use warnings;

use CGI;
use Data::Dumper;

my $q = CGI->new;
my %data;


$data{name} = $q->param('name');
$data{email} = $q->param('email');
$data{message} = $q->param('message');
my $key  = $q->param('g-recaptcha-response');
$data{remoteip} = $q->remote_host();
if (&verifyCaptcha($key)) {
	&sendEmail(\%data);
	print $q->header();
}
else {
	print "$ENV{SERVER_PROTOCOL} 500\n";
}

exit 0;


sub verifyCaptcha {
	my $secret = "ask agoldis\@gmail.com";
	my $url = "https://www.google.com/recaptcha/api/siteverify";
	my $key = shift;
	return 0 if ($key eq "" or !defined $key);

	my $curl = `which curl`;
	chomp $curl;
	my $data = "secret=$secret&response=$key";
	my $cmd = "$curl --data \"$data\" $url";
	my @result = `$cmd`;
	while(my $line = pop @result) {
		next unless $line =~ /"success"\:\s+(\w+)/;
		return 1 if $1 eq "true";
		return 0;
	}
}

sub sendEmail {
	my $data = shift;
	my $sendmail = "/usr/sbin/sendmail -t";
	my $from = "robot\@bartrapp.com";
	my $to = "support\@bartrapp.com";
	my $subject = "New message via bartrapp.com from: ". $data->{name};
	my $message = <<"MSG";
New messag via bartrapp.com
Name: $data->{name}
Email: $data->{email}
Message: $data->{message}

Regards, Robot.
MSG
	open SENDMAIL, "|$sendmail" or die "Cannot open sendmail: $!";
	print SENDMAIL "To: $to\n";
	print SENDMAIL "From: $from\n";
	print SENDMAIL "Subject: $subject\n";
	print SENDMAIL "Content-type: text/plain\n\n";
	print SENDMAIL $message;
	close(SENDMAIL);
}
