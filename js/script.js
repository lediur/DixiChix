$(document).ready(function() {
	var submitButton = $("#contact-us-button");
	console.log(submitButton);
	var nameInput = $("#contact-name");
	var emailInput = $("#contact-email");
	var messageInput = $("#contact-message");

	// var successAlert = $('#contact-alert-success');
	// var failAlert = $('#contact-alert-fail');

	submitButton.on("click", function() {
		event.preventDefault();
		
		// successAlert.style.display = 'none';
		// failAlert.style.display = 'none';

		console.log('submit button clicked');
		console.log(emailInput.val());
		console.log(nameInput.val());
		console.log(messageInput.val());

		if (validateEmail(emailInput.val()) && nameInput.val() != "" && messageInput.val() != "") {

			$.ajax({
				url: "email.php",
				type: "POST",
				dataType: 'json',
				data: {
					name: nameInput.val(),
					email: emailInput.val(),
					message: messageInput.val()
				},
				// success: function (data) {
				// 	console.log("email success!", data);
				// 	setTimeout(function() {
		  //     			successAlert.style.display = "block";
		  //     			// scrollToBottom();
				//     }, 300);
				// }
			});
		}
		else {
			console.log("not a valid input");
			// setTimeout(function() {
		 //      failAlert.style.display = "block";
		 //      scrollToBottom();
		 //    }, 300);
		}
	});
});

function validateEmail(email) {
  var re = new RegExp("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
  return re.test(email);
}