$(document).ready(function(){

	var isValidUsername = 0;
	var isValidEmail = 0;
	var isValidPassword = 0;
	var isMatchPassword = 0;

	// Disable registration submit button
	$('#subscriptionBtn').attr('disabled', 'disabled');

	// Hide results text fields
	$("form .alert").hide();

	// Check for subscription username validity
	$("#registrationUserName").blur(function() {

		var userName = $(this).val();
		var cfcPath = $(this).data("path");
		
		if (userName) {
			$.ajax({
				type: "post",
				url: cfcPath + "cfc/registration.cfc?method=verifyUsernameJSON",
				data: {
					"userName" : userName,
					"dataSource" : "flyvalle_db",
					"tableName" : "users",
					"columnName" : "username"
				},
				dataType: "JSON",
				success: function(data) {
					//alert(path);
					if(data.status == "Error") {
						$('#username-alert').removeClass().addClass('alert alert-dismissable alert-warning').show('fast');
						$('#username-alert span').html(data.message);
					}
					else {
						isValidUsername = 1;
						$('#username-alert').css('display','none');
					}
				},
				error: function (){
					$('#username-alert').removeClass().addClass('alert alert-dismissable alert-danger').show('fast');
					$('#username-alert span').html('Error connecting with the database');
					//alert("error");
				}
			});
		}

	});

	// Check for subscription email validity
	$("#registrationEmail").blur(function() {

		var userEmail = $(this).val();
		var path = $(this).data("path");
		
		if (userEmail) {
			$.ajax({
				type: "post",
				url: path + "cfc/registration.cfc?method=verifyEmailJSON",
				data: {
					"userEmail" : userEmail,
					"dataSource" : "flyvalle_db",
					"tableName" : "users",
					"columnName" : "email"
				},
				dataType: "JSON",
				success: function(data) {
					//alert(path);
					if(data.status == "Error") {
						$('#email-alert').removeClass().addClass('alert alert-dismissable alert-warning').show('fast');
						$('#email-alert span').html(data.message);
					}
					else {
						isValidEmail = 1;
						$('#email-alert').css('display','none');
					}
				},
				error: function (){
					$('#email-alert').removeClass().addClass('alert alert-dismissable alert-danger').show('fast');
					$('#email-alert span').html('Error connecting with the database');
					//alert("error");
				}
			});
		}

	});

	// Check for subscription password validity
	$("#registrationPassword").keyup(function() {

		var userPassword = $(this).val();
		var confPassword = $('#registrationConfirmPassword').val();
		var path = $(this).data("path");
		
		if (userPassword) {
			$.ajax({
				type: "post",
				url: path + "cfc/registration.cfc?method=verifyPasswordJSON",
				data: {
					"password" : userPassword,
					"confirmPassword" : confPassword
				},
				dataType: "JSON",
				success: function(data) {
					//alert(path);
					if(data.status == "Error") {
						isValidPassword = 0;
						$('#password-alert').removeClass().addClass('alert alert-dismissable alert-danger').show('fast');
						$('#password-alert span').html(data.message);
					}
					else {
						isValidPassword = 1;
						$('#password-alert').removeClass().addClass('alert alert-dismissable alert-warning').show('fast');
						$('#password-alert span').html(data.message);
					}
				},
				error: function (){
					$('#password-alert').removeClass().addClass('alert alert-dismissable alert-danger').show('fast');
					$('#password-alert span').html('Error connecting with the database');
					//alert("error");
				}
			});
		}

	});

	// Check for subscription password confirmation
	$("#registrationConfirmPassword").keyup(function() {

		var confPassword = $(this).val();
		var userPassword = $('#registrationPassword').val();
		
		if (userPassword == confPassword) {
			isMatchPassword = 1;
			$('#password-alert').removeClass().addClass('alert alert-dismissable alert-success').show('fast');
			$('#password-alert span').html("The value entered is a match");
		}
		else {
			isMatchPassword = 0;
			$('#password-alert').removeClass().addClass('alert alert-dismissable alert-danger').show('fast');
			$('#password-alert span').html("The value entered do not match");
		}

	});

	// Terms and Conditions agreement
	$("#termsAgreement").click(function() {
	    // this function will get executed every time the #home element is clicked (or tab-spacebar changed)
	    if($(this).is(":checked"))
	    {
	    	$('#subscriptionBtn').removeAttr("disabled");
	    }
	    else {
	    	$('#subscriptionBtn').attr("disabled", true);
	    }
	});

	// Send registration data
	$("#subscriptionForm").submit(function(event) {

		event.preventDefault();

		if(isValidUsername == 1 && isValidEmail == 1 && isValidPassword == 1 && isMatchPassword == 1) {
		
			dataString = $("#subscriptionForm").serialize();
			password = $("#registrationPassword").val();
			email = $("#registrationEmail").val();

		    $.ajax({
		    	type: "post",
		   		url: "cfc/registration.cfc?method=insertNewUserJSON",
		    	data: dataString,
		    	dataType: "json",
		    	success: function(data) {
					if (data.status == "Error") {
						$('#mailListAlert').addClass('alert alert-danger mt-1').show('fast');
						$("#agreement-alert span").html("Error: " + data.message);
					}
					else {
						insertPassword(email, password, data.userID, data.challengeCode);
					}						      
				},
				error: function (){
					$('#mailListAlert').addClass('alert alert-danger mt-1').show('fast');
					$("#agreement-alert span").html("Error: Connection with the component was not established (username)");
				}
			});
		}
		else {
			$('#agreement-alert').removeClass().addClass('alert alert-danger mt-1').show('fast');
			$("#agreement-alert span").html("Please fill the info in all the required fields");
		}
	});
	
	function insertPassword(email, password, userID, challengeCode) {
		//alert(password + userID + challengeCode);

	    $.ajax({
	    	type: "post",
	   		url: "cfc/registration.cfc?method=insertPasswordJSON",
	    	data: {
	    		"email" : email,
				"password" : password,
				"userID" : userID,
				"challengeCode" : challengeCode
			},
	    	dataType: "json",
	    	success: function(data) {
				if (data.status == "Error") {
					$('#mailListAlert').addClass('alert alert-danger mt-1').show('fast');
					$("#agreement-alert span").html("Error: " + data.message);
				}
				else {
					sendConfirmationEmail(email, data.emailChallenge);
				}						      
			},
			error: function (){
				$('#agreement-alert').addClass('alert alert-danger mt-1').show('fast');
				$("#agreement-alert span").html("Error: Connection with the component was not established (password)");
			}
		});
	};

	function sendConfirmationEmail(email, emailChallenge) {
		//alert(emailChallenge);
	    $.ajax({
	    	type: "post",
	   		url: "cfc/registration.cfc?method=sendEmailJSON",
	    	data: {
	    		"email" : email,
				"challengeCode" : emailChallenge
			},
	    	dataType: "json",
	    	success: function(data) {
				if (data.status == "Error") {
					$('#mailListAlert').removeClass().addClass('alert alert-danger mt-1').show('fast');
					$("#agreement-alert span").html("Error: " + data.message);
				}
				else {
					$('#agreement-alert').removeClass().addClass('alert alert-success mt-1').show('fast');
					$("#agreement-alert span").html("Success! " + data.message);
				}						      
			},
			error: function (){
				$('#agreement-alert').removeClass().addClass('alert alert-danger mt-1');
				$("#agreement-alert span").html("Error: Connection with the component was not established (validation email was not sent)");
			}
		});
	};

	$("form input").focus(function() {
		$('form .alert').hide('fast');
	});

});