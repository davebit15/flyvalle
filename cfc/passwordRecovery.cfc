/*
* Created by bit15, 2017
*/

component accessors = false output = false persistent = false {

	remote function verifyEmailJSON(required string userEmail, string datasource, string tableName, string columnName) output = "false" returnformat="JSON" {

		emailCheckResponse = structNew();
		emailCheckResponse["status"] = "";
		emailCheckResponse["message"] = "";

		if(structKeyExists(arguments, "userEmail") AND isValid("email", arguments.userEmail)) {
			if(structKeyExists(arguments, "datasource") AND arguments.datasource NEQ "" AND structKeyExists(arguments, "tableName") AND arguments.tableName NEQ "" AND structKeyExists(arguments, "columnName") AND arguments.columnName NEQ "") {
				emailExistsQuery = new Query();
				emailExistsQuery.setDatasource(arguments.datasource);
				emailExistsQuery.setSQL("
					SELECT *
					FROM #arguments.tableName#
					WHERE #arguments.columnName# = '#arguments.userEmail#'
				");

				try {
					emailExistsResults = emailExistsQuery.execute();

					emailExists = emailExistsResults.getResult();

					if (emailExists.recordCount GT 0) {
						emailCheckResponse["status"] = "Success";
						emailCheckResponse["message"] = "<p>The email <strong>" & arguments.userEmail & "</strong> is registered.</p> <p>Click on <strong>Change Password</strong> to initiate the proccess to change your account password.</p>";
					}
					else {
						emailCheckResponse["status"] = "Error";
						emailCheckResponse["message"] = "The email provided is not in our records.";
					}
				}
				catch(any e) {
					emailCheckResponse["status"] = "Error";
					emailCheckResponse["message"] = "There was an error querying " & arguments.datasource & "." & arguments.tableName & "." & arguments.columnName& " - " &  e;
				}

			}
			else {
				emailCheckResponse["status"] = "Error";
				emailCheckResponse["message"] = "The email provided is a valid email address, but the information required for quering the database is missing. Please contact support for help.";
			}
		}
		else {
			emailCheckResponse["status"] = "Error";
			emailCheckResponse["message"] = "The email provided is not a valid email address.";
		}

		return serializeJSON(emailCheckResponse);
	} /* end function **verifyEmailJSON** */

	remote function sendPassResetEmail(required string userEmail, string datasource, string tableName, string columnName) output = "false" returnformat="JSON" {

		emailCheckResponse = structNew();
		emailCheckResponse["status"] = "";
		emailCheckResponse["message"] = "";

		if(structKeyExists(arguments, "userEmail") AND isValid("email", arguments.userEmail)) {
			if(structKeyExists(arguments, "datasource") AND arguments.datasource NEQ "" AND structKeyExists(arguments, "tableName") AND arguments.tableName NEQ "" AND structKeyExists(arguments, "columnName") AND arguments.columnName NEQ "") {
				getEmailInfoQuery = new Query();
				getEmailInfoQuery.setDatasource(arguments.datasource);
				getEmailInfoQuery.setSQL("
					SELECT *
					FROM #arguments.tableName#
					WHERE #arguments.columnName# = '#arguments.userEmail#'
				");

				try {
					getInfoResults = getEmailInfoQuery.execute();

					emailInfo = getInfoResults.getResult();

					if (emailInfo.recordCount GT 0) {

						// Send email

						emailCheckResponse["status"] = "Success";
						emailCheckResponse["message"] = "<p>An email containing a link to the Password Change page was sent to <strong>" & arguments.userEmail & "</strong>.</p> <p>Please check your email and follow the procedure to create a new password for your account.</p>";
					}
					else {
						emailCheckResponse["status"] = "Error";
						emailCheckResponse["message"] = "The email provided is not in our records. Please provide the email you used when you initially registered.";
					}
				}
				catch(any e) {
					emailCheckResponse["status"] = "Error";
					emailCheckResponse["message"] = "There was an error querying " & arguments.datasource & "." & arguments.tableName & "." & arguments.columnName& " - " &  e;
				}

			}
			else {
				emailCheckResponse["status"] = "Error";
				emailCheckResponse["message"] = "The email provided is a valid email address, but the information required for quering the database is missing. Please contact support for help.";
			}
		}
		else {
			emailCheckResponse["status"] = "Error";
			emailCheckResponse["message"] = "The email provided is not a valid email address.";
		}

		return serializeJSON(emailCheckResponse);
	}

	remote function verifyPasswordJSON(required string password) output = "false" returnformat="JSON" {

		passwordCheckResponse = structNew();
		passwordCheckResponse["status"] = "";
		passwordCheckResponse["message"] = "";
		passwordCheckResponse["strength"] = 0;

		if(structKeyExists(arguments, "password") AND len(arguments.password) GTE 8) {
			if(len(arguments.password) GT 16) {
				passwordCheckResponse["status"] = "Error";
				passwordCheckResponse["message"] = "Your password is too long: it must be between 8 and 16 characters long";
				passwordCheckResponse["strength"] = 0;
			}
			else {
				passwordCheckResponse["strength"] = 1;

				if(reFind("[A-Z]", arguments.password)) {
					passwordCheckResponse["strength"] = passwordCheckResponse["strength"] + 1;
				}
				if(reFind("[a-z]", arguments.password)) {
					passwordCheckResponse["strength"] = passwordCheckResponse["strength"] + 1;
				}
				if(reFind("[0-9]", arguments.password)) {
					passwordCheckResponse["strength"] = passwordCheckResponse["strength"] + 1;
				}
				if(reFind("[!$%_*+]", arguments.password)) {
					passwordCheckResponse["strength"] = passwordCheckResponse["strength"] + 1;
				}

				passwordCheckResponse["message"] = "Your password strength is " & passwordCheckResponse["strength"];
			}
		}
		else {
			passwordCheckResponse["status"] = "Error";
			passwordCheckResponse["message"] = "Your password is too short: it must be between 8 and 16 characters long";
			passwordCheckResponse["strength"] = 0;
		}

		return serializeJSON(passwordCheckResponse);
	} /* end function **verifyPasswordJSON** */

	remote function insertPasswordJSON(string password, string email, numeric userID, string challengeCode, string datasource) output = "false" returnformat="JSON" {
		
		var passResponse = StructNew();
		passResponse["status"] = "";
		passResponse["message"] = "";
		passResponse["userID"] = "";
		passResponse["email"] = "";
		passResponse["challengeCode"] = "";
		passResponse["emailChallenge"] = "";

		if (structKeyExists(arguments, "password") AND arguments.password NEQ "") {
			/* Password hash */
			hashedPassword = Hash(arguments.password, "SHA-512" , "utf-8", 1000);
		}
		else if (structKeyExists(FORM, "password") AND FORM.password NEQ "") {
			hashedPassword = Hash(FORM.password, "SHA-512" , "utf-8", 1000);
		}
		else {
			passResponse.status = "Error";
			passResponse.message = "Password was not provided";
			return passResponse;
		}

		if (structKeyExists(arguments, "email") AND arguments.email NEQ "") {
			passResponse.email = arguments.email;
		}
		else if (structKeyExists(FORM, "email") AND FORM.email NEQ "") {
			passResponse.email = FORM.email;
		}
		else {
			passResponse.status = "Error";
			passResponse.message = "Email was not provided";
			return passResponse;
		}

		if (structKeyExists(arguments, "challengeCode") AND arguments.challengeCode NEQ "") {
			challengeCode = arguments.challengeCode;
		}
		else if (structKeyExists(FORM, "challengeCode") AND FORM.challengeCode NEQ "") {
			challengeCode = FORM.challengeCode;
		}
		else {
			passResponse.status = "Error";
			passResponse.message = "The challenge code was not provided";
			return passResponse;
		}

		if (structKeyExists(arguments, "userID") AND arguments.userID NEQ 0) {
			userID = arguments.userID;
		}		
		else if (structKeyExists(FORM, "userID") AND FORM.userID NEQ 0) {
			userID = FORM.userID;
		}
		else {
			passResponse.status = "Error";
			passResponse.message = "User ID was not provided";
			return passResponse;
		}
		if (structKeyExists(arguments, "datasource") AND arguments.datasource NEQ "") {
			datasource = arguments.datasource;
		}
		else if (structKeyExists(FORM, "datasource") AND FORM.datasource NEQ "") {
			datasource = FORM.datasource;
		}
		else if (structKeyExists(Application, "dsn") AND Application.dsn NEQ "") {
			datasource = Application.dsn;
		}
		else {
			passResponse.status = "Error";
			passResponse.message = "Valid datasource value was not provided";
			return passResponse;
		}

		insertData = new Query();
		insertData.setDatasource(datasource);
		insertData.setSQL("
			INSERT INTO passwords (password, userID, creationDate)
			VALUES ('#hashedPassword#', #userID#, #CreateODBCDateTime(Now())#)
		");
		try {
			insertResult = insertData.execute();
		}
		catch (any e) {
			passResponse.status = "Error";
			passResponse.message = "Database insert error: " & e;
			return passResponse;
		}

		passResponse.userID = userID;
		passResponse.email = email;
		passResponse.challengeCode = challengeCode;
		passResponse.emailChallenge = userID & challengeCode;
		passResponse.status = "Success";
		passResponse.message = "The password for the new account was successfully set";

		return serializeJSON(passResponse);
	} /* end function **insertPasswordJSON** */

	remote function sendEmailJSON(string email, string challengeCode) output = "false" returnformat="JSON" {

		var emailResponse = StructNew();
		emailResponse["status"] = "";
		emailResponse["message"] = "";

		if (structKeyExists(arguments, "email") AND arguments.email NEQ "") {
			email = arguments.email;
		}
		else if (structKeyExists(FORM, "email") AND FORM.email NEQ "") {
			email = FORM.email;
		}
		else {
			emailResponse.status = "Error";
			emailResponse.message = "Email was not provided";
			return emailResponse;
		}

		if (structKeyExists(arguments, "challengeCode") AND arguments.challengeCode NEQ "") {
			challengeCode = arguments.challengeCode;
		}
		else if (structKeyExists(FORM, "challengeCode") AND FORM.challengeCode NEQ "") {
			challengeCode = FORM.challengeCode;
		}
		else {
			emailResponse.status = "Error";
			emailResponse.message = "Some information is missing. Please contact support.";
			return emailResponse;
		}

		savecontent variable="emailBody" {
			writeOutput("
				<br/>
				Thank you for taking the time to register!<br/>
				To validate your email address, please click on the link below:<br/>
				<a href='http://flyvalle.com/login.cfm?validate_email=yes&challenge=#challengeCode#'>http://flyvalle.com/login.cfm?validate_email=yes&challenge=#challengeCode#</a>
			");	
		}

		mailService = new mail(
		  to = "#email#",
		  from = "#Application.registrationEmail#",
		  subject = "FlyValle Registration Validation",
		  body = emailBody,
		  type = "html"
		);

		try {
			mailService.send();
		}
		catch (any e){
			emailResponse.status = "Error";
			emailResponse.message = "The confirmation email was not sent (" & e & "). Please contact support.";
			return emailResponse;
		}

		emailResponse.status = "Success";
		emailResponse.message = "We sent you a message with the subject 'FlyValle Registration Validation' to <strong>" & email & ".</strong><br/> To complete the registration proccess, please click the link on the email message to validate your email address.";

		return serializeJSON(emailResponse);
	}

}