/*
* Created by bit15, 2017
*/

component accessors = false output = false persistent = false {

	remote function insertNewUserJSON(string datasource, string username, string firstName, string lastName, string email, numeric gender, date birthDate, numeric role) output = "false" returnformat="JSON" {

		var userData = StructNew();
		var regResponse = StructNew();
		regResponse["status"] = "";
		regResponse["message"] = "";
		regResponse["userID"] = "";
		regResponse["challengeCode"] = "";

		/* Random validation code */
		strLowerCaseAlpha = "abcdefghijklmnopqrstuvwxyz";
		strUpperCaseAlpha = UCase(strLowerCaseAlpha);
		strNumbers = "0123456789";
		strOtherChars = "_@$";

		strLen = 16;
		strAllValidChars = (strLowerCaseAlpha & strUpperCaseAlpha & strNumbers & strOtherChars);
		arrCode = ArrayNew(1);

		for (i = 1; i <= strLen; i++) {
			arrCode[i] = Mid(strAllValidChars, RandRange(1, Len(strAllValidChars)), 1);
		}

		userData.strCode = ArrayToList(arrCode, ""); /* Validation code to be sent by email */
		/* Random validation code */

		if (structKeyExists(arguments, "username") AND arguments.username NEQ "") {
			userData.username = arguments.username;
		}
		else if (structKeyExists(FORM, "username") AND FORM.username NEQ "") {
			userData.username = FORM.username;
		}
		else {
			regResponse.status = "Error";
			regResponse.message = "Username value was not provided";
			return regResponse;
		}

		if (structKeyExists(arguments, "firstName") AND arguments.firstName NEQ "") {
			userData.firstName = arguments.firstName;
		}
		else if (structKeyExists(FORM, "firstName") AND FORM.firstName NEQ "") {
			userData.firstName = FORM.firstName;
		}
		else {
			userData.firstName = "";
		}

		if (structKeyExists(arguments, "lastName") AND arguments.lastName NEQ "") {
			userData.lastName = arguments.lastName;
		}
		else if (structKeyExists(FORM, "lastName") AND FORM.lastName NEQ "") {
			userData.lastName = FORM.lastName;
		}
		else {
			userData.lastName = "";
		}

		if (structKeyExists(arguments, "email") AND isValid("email",arguments.email)) {
			userData.email = arguments.email;
		}
		else if (structKeyExists(FORM, "email") AND isValid("email",FORM.email)) {
			userData.email = FORM.email;
		}
		else {
			regResponse.status = "Error";
			regResponse.message = "Valid email value was not provided";
			return regResponse;
		}

		if (structKeyExists(arguments, "gender") AND isValid("integer",arguments.gender)) {
			userData.gender = arguments.gender;
		}
		else if (structKeyExists(FORM, "gender") AND isValid("integer",FORM.gender)) {
			userData.gender = FORM.gender;
		}
		else {
			userData.gender = "";
		}

		if (structKeyExists(arguments, "birthDate") AND isValid("usdate",arguments.birthDate)) {
			userData.birthDate = arguments.birthDate;
		}
		else if (structKeyExists(FORM, "birthDate") AND isValid("usdate",FORM.birthDate)) {
			userData.birthDate = FORM.birthDate;
		}
		else {
			userData.birthDate = "";
		}

		if (structKeyExists(arguments, "role") AND arguments.role NEQ "") {
			userData.role = arguments.role;
		}
		else if (structKeyExists(FORM, "role") AND FORM.role NEQ "") {
			userData.role = FORM.role;
		}
		else {
			userData.role = 0;
		}

		if (structKeyExists(arguments, "datasource") AND arguments.datasource NEQ "") {
			userData.datasource = arguments.datasource;
		}
		else if (structKeyExists(FORM, "datasource") AND FORM.datasource NEQ "") {
			userData.datasource = FORM.datasource;
		}
		else if (structKeyExists(Application, "dsn") AND Application.dsn NEQ "") {
			userData.datasource = Application.dsn;
		}
		else {
			regResponse.status = "Error";
			regResponse.message = "Valid datasource value was not provided";
			return regResponse;
		}

		insertData = new Query();
		insertData.setDatasource(userData.datasource);
		insertData.setSQL("
			INSERT INTO users (username, firstName, lastName, email, gender, strCode, creationDate)
			VALUES ('#userData.username#','#userData.firstName#', '#userData.lastName#', '#userData.email#', '#userData.gender#', '#userData.strCode#', #CreateODBCDateTime(Now())#)
		");

		try {
			insertResult = insertData.execute();
		}
		catch (any e) {
			regResponse.status = "Error";
			regResponse.message = "Database insert error: " & e;
			return regResponse;
		}

		regResponse.userID = insertResult.getPrefix().generatedKey;

		insertRole = new Query();
		insertRole.setDatasource(userData.datasource);
		insertRole.setSQL("
			INSERT INTO access (userID, accessLvl, creationDate)
			VALUES (#regResponse.userID#, #userData.role#, #CreateODBCDateTime(Now())#)
		");
		
		try {
			insertResult = insertRole.execute();
		}
		catch (any e) {
			regResponse.status = "Error";
			regResponse.message = "Database insert error: " & e;
			return regResponse;
		}

		regResponse.status = "Success";
		regResponse.message = "Personal data inserted.";
		regResponse.challengeCode = userData.strCode;

		return serializeJSON(regResponse);
	} /* end function **insertNewUserJSON** */

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

	remote function insertNewAddressJSON(numeric userID, string address1, string address2, string city, string state, string zip, string country, integer type, string datasource) output = "false" returnformat="JSON" {
		
		addrResponse = StructNew();

		/* datasource */
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
			addrResponse.status = "error";
			addrResponse.message = "Valid datasource value was not provided";
			return addrResponse;
		}
		/* userID */
		if (structKeyExists(arguments, "userID") AND isValid(integer, arguments.userID) AND arguments.userID NEQ 0) {
			userID = arguments.userID;
		}
		else if (structKeyExists(FORM, "userID") AND isValid(integer, FORM.userID)  AND FORM.userID NEQ 0) {
			userID = FORM.userID;
		}
		else {
			addrResponse.status = "error";
			addrResponse.message = "The user ID is not defined.";
			return addrResponse;
		}
		/* address */		
		if (structKeyExists(arguments, "address1") AND arguments.address1 NEQ "") {
			address1 = arguments.address1;
		}
		else if (structKeyExists(FORM, "address1") AND FORM.address1 NEQ "") {
			address1 = FORM.address1;
		}
		else {
			addrResponse.status = "error";
			addrResponse.message = "The address was not provided.";
			return addrResponse;
		}
		/* city */		
		if (structKeyExists(arguments, "city") AND arguments.city NEQ "") {
			city = arguments.city;
		}
		else if (structKeyExists(FORM, "city") AND FORM.city NEQ "") {
			city = FORM.city;
		}
		else {
			addrResponse.status = "error";
			addrResponse.message = "The city was not provided.";
			return addrResponse;
		}
		/* state */
		if (structKeyExists(arguments, "state") AND arguments.state NEQ "") {
			state = arguments.state;
		}
		else if (structKeyExists(FORM, "state") AND FORM.state NEQ "") {
			state = FORM.state;
		}
		else {
			addrResponse.status = "error";
			addrResponse.message = "The state was not provided.";
			return addrResponse;
		}
		/* zip */
		if (structKeyExists(arguments, "zip") AND arguments.zip NEQ "") {
			zip = arguments.state;
		}
		else if (structKeyExists(FORM, "zip") AND FORM.zip NEQ "") {
			zip = FORM.zip;
		}
		else {
			addrResponse.status = "error";
			addrResponse.message = "The zip code was not provided.";
			return addrResponse;
		}
		/* country */
		if (structKeyExists(arguments, "country") AND arguments.country NEQ "") {
			country = arguments.country;
		}
		else if (structKeyExists(FORM, "country") AND FORM.country NEQ "") {
			country = FORM.country;
		}
		else {
			addrResponse.status = "error";
			addrResponse.message = "The country was not provided.";
			return addrResponse;
		}
		/* type of address (0-General, unspecified 1-Personal postal address 2-Credit Card address 3-Shipping address) */
		if (structKeyExists(arguments, "type") AND arguments.type GTE 0) {
			type = arguments.type;
		}
		else if (structKeyExists(FORM, "type") AND FORM.type GTE 0) {
			type = FORM.type;
		}
		else {
			addrResponse.status = "error";
			addrResponse.message = "The type was not provided.";
			return addrResponse;
		}

		insertData = new Query();
		insertData.setDatasource(datasource);
		insertData.setSQL("
			INSERT INTO addresses (userID, address1, address2, city, state, zip, country, type, creationDate)
			VALUES (#userID#, '#address1#', '#address2#', '#city#', '#state#', '#zip#', '#country#', #type#, #CreateODBCDateTime(Now())#)
		");
		try {
			insertResult = insertData.execute();
		}
		catch (any e) {
			addrResponse.status = "error";
			addrResponse.message = "Database insert error: " & e;
			return addrResponse;
		}

		addrResponse.userID = userID;
		addrResponse.status = "success";
		addrResponse.massage = "The address was successfully added";

		return addrResponse;
	}

	remote function editUserInfoJSON() output = "false" returnformat="JSON" {
		/* TODO: Implement Method */
		return "";
	}

	remote function editUserAddressJSON() output = "false" returnformat="JSON" {
		/* TODO: Implement Method */
		return "";
	}	

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
						emailCheckResponse["status"] = "Error";
						emailCheckResponse["message"] = "<p>The email <strong>" & arguments.userEmail & "</strong> is already being used.</p> <p>You can <a href='login.cfm'><strong>login</strong></a> using this email and the password entered when it was registered.</p> <p>If you don't remember the password, please follow the procedure for recovering a <a href='recover-password.cfm'><strong>lost password</strong></a>.</p> <p>If you believe this is an error, please <a href='contact.cfm'><strong>contact us</strong></a>.</p>";
					}
					else {
						emailCheckResponse["status"] = "Success";
						emailCheckResponse["message"] = "The email provided is a valid email address and is not already in our records";
					}
				}
				catch(any e) {
					emailCheckResponse["status"] = "Error";
					emailCheckResponse["message"] = "There was an error querying " & arguments.datasource & "." & arguments.tableName & "." & arguments.columnName& " - " &  e;
				}

			}
			else {
				emailCheckResponse["status"] = "Success";
				emailCheckResponse["message"] = "The email provided is a valid email address";
			}
		}
		else {
			emailCheckResponse["status"] = "Error";
			emailCheckResponse["message"] = "The email provided is not a valid email address";
		}

		return serializeJSON(emailCheckResponse);
	} /* end function **verifyEmailJSON** */	

	remote function verifyUsernameJSON(required string username, string datasource, string tableName, string columnName) output = "false" returnformat="JSON" {

		usernameCheckResponse = structNew();
		usernameCheckResponse["status"] = "";
		usernameCheckResponse["message"] = "";

		if(structKeyExists(arguments, "username") AND len(arguments.username) GT 2 AND len(arguments.username) LTE 30 ) {
			if(structKeyExists(arguments, "datasource") AND arguments.datasource NEQ "" AND structKeyExists(arguments, "tableName") AND arguments.tableName NEQ "" AND len(arguments.tableName) LTE 20 AND structKeyExists(arguments, "columnName") AND arguments.columnName NEQ "") {
				usernameExistsQuery = new Query();
				usernameExistsQuery.setDatasource(arguments.datasource);
				usernameExistsQuery.setSQL("
					SELECT *
					FROM #arguments.tableName#
					WHERE #arguments.columnName# = '#arguments.username#'
				");

				try {
					usernameExistsResults = usernameExistsQuery.execute();

					usernameExists = usernameExistsResults.getResult();

					if (usernameExists.recordCount GT 0) {
						usernameCheckResponse["status"] = "Error";
						usernameCheckResponse["message"] = "<p>The username <strong>" & arguments.username & "</strong> is already being used.</p> <p>Please choose a different username.</p> <p>If you believe this is an error, please <a href='contact.cfm'><strong>contact us</strong></a>.</p>";
					}
					else {
						usernameCheckResponse["status"] = "Success";
						usernameCheckResponse["message"] = "The username entered is valid and is not in use";
					}
				}
				catch(any e) {
					usernameCheckResponse["status"] = "Error";
					usernameCheckResponse["message"] = "There was an error querying " & arguments.datasource & "." & arguments.tableName & "." & arguments.columnName& " - " &  e;
				}

			}
			else {
				usernameCheckResponse["status"] = "Success";
				usernameCheckResponse["message"] = "The username provided is valid";
			}
		}
		else {
			usernameCheckResponse["status"] = "Error";
			usernameCheckResponse["message"] = "Please enter a username at least 3 characters long";
		}

		return serializeJSON(usernameCheckResponse);
	} /* end function **verifyEmailJSON** */

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

	public function validateEmail(required string challengeCode, string datasource) output = "false" {

		userID = left(URL.challenge, len(arguments.challengeCode) - 16);
		challenge = right(arguments.challengeCode, 16);
		datasource = "";
		emailValResponse["status"] = "";
		emailValResponse["message"] = "";

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
			emailValResponse.status = "Error";
			emailValResponse.message = "Valid datasource value was not provided";
			return emailValResponse;
		}

		emailVerify = new Query();
		emailVerify.setDatasource(datasource);
		emailVerify.setSQL("
			UPDATE users
			SET emailVerified = 1
			WHERE ID = #userID# AND strCode = '#challenge#'
		");

		try {
			updateEmailVer = emailVerify.execute();
		}
		catch(any e) {
			return e;
		}
		
		return emailValResponse;
	}

}