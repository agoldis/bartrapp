$( document ).ready( function () {

  // init background slideshow
  $('#welcome-section').backstretch([
        "img/bg/001.jpg",
        "img/bg/002.jpg",
        "img/bg/003.jpg",
        "img/bg/004.jpg",
        "img/bg/005.jpg",
        "img/bg/006.jpg",
    ], {duration: 3000, fade: 750});
    var displaySuccess = function (data) {
	$('#form-wrapper').fadeOut();
	$('#form-result-message').html('Thank you!').fadeIn();
    };
    var displayFail = function (data) {
	$('#form-wrapper').fadeOut();
	$('#form-result-message').html('Cannot send email, please contact support@bartrapp.com').fadeIn();

    };

    $('#submit-button').click( function(e) { 
	e.preventDefault();
	var data = {};
	data.name = $("input[name='name']").val();
	data.email = $("input[name='email']").val();
	data.message = $("textarea[name='message']").val();
	data['g-recaptcha-response'] = grecaptcha.getResponse();
	console.dir(data);
	$.post('cgi-bin/mailer.pl', data)
	.success(displaySuccess)
	.fail(displayFail)
 	.done();
	});

});

