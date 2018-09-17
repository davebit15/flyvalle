/*
* Created by bit15, 2017 2302222242
*/

component accessors = true output = false persistent = false {

	/* If encryption key is not provided as an argument nor is defined in Application.cfc, this will be used */
	encryptionKey = "3ncrypt_3veryth1n6";

	/* Login user providing email, password, and datasource */
	remote function loginUserJSON(string loginUsername, string loginPassword, string datasource, integer rememberMe) output = "false" hint = "Returns the loginResponse structure" returnFormat = "JSON" {

		loginResponse = structNew();
		loginResponse["status"] = "";
		loginResponse["message"] = "";
		loginResponse["loginData"] = "";

		userEmail = "";
		userName = "";
		hashedPassword = "";
		dsn = "";

		if (structKeyExists(arguments, "loginUsername") AND arguments.loginUsername IS NOT "") {
			if (isValid("email", arguments.loginUsername)) {
				userEmail = arguments.loginUsername;
			}
			else {
				userName = arguments.loginUsername;
			}			
		}
		else if (structKeyExists(FORM, "loginUsername") AND FORM.loginUsername IS NOT "") {
			if (isValid("email", FORM.loginUsername)) {
				userEmail = FORM.loginUsername;
			}
			else {
				userName = FORM.loginUsername;
			}			
		}
		else {
			loginResponse.status = "Error";
			loginResponse.message = "The login username/email was not provided";
			return serializeJSON(loginResponse);
		}

		if (structKeyExists(arguments, "loginPassword") AND arguments.loginPassword IS NOT "") {
			hashedPassword = hash(arguments.loginPassword, "SHA-512" , "utf-8", 1000);
		}
		else if (structKeyExists(FORM, "loginPassword") AND FORM.loginPassword IS NOT "") {
			hashedPassword = hash(FORM.loginPassword, "SHA-512" , "utf-8", 1000);
		}
		else {
			loginResponse.status = "Error";
			loginResponse.message = "The login password was not provided";
			return serializeJSON(loginResponse);
		}

		if(structKeyExists(arguments, "datasource") AND arguments.datasource IS NOT "") {
			dsn = arguments.datasource;
		}
		else if(structKeyExists(Application, "dsn") AND Application.dsn IS NOT "") {
			dsn = Application.dsn;
		}
		else {
			loginResponse.status = "Error";
			loginResponse.message = "The datasource is not defined";
			return serializeJSON(loginResponse);
		}

		loginQuery = new Query();
		loginQuery.setDatasource(dsn);

		if(len(userName) GT 2) {
			loginQuery.setSQL("
				SELECT users.ID AS ID, username, firstName, lastName, email, accessLvl
				FROM users
				LEFT JOIN passwords ON users.ID = passwords.userID
				LEFT JOIN access ON users.ID = access.userID
				WHERE users.username = '#userName#' AND passwords.password = '#hashedPassword#' AND users.emailVerified = 1
			");
		}

		if(len(userEmail) GT 7) {
			loginQuery.setSQL("
				SELECT users.ID AS ID, username, firstName, lastName, email, accessLvl
				FROM users
				LEFT JOIN passwords ON users.ID = passwords.userID
				LEFT JOIN access ON users.ID = access.userID
				WHERE users.email = '#userEmail#' AND passwords.password = '#hashedPassword#' AND users.emailVerified = 1
			");
		}

		try {
			queryResponse = loginQuery.execute();
			queryResult = queryResponse.getResult();
		}
		catch (database e) {
			loginResponse.status = "Error";
			loginResponse.message = "Database error! " & e;
			return serializeJSON(loginResponse);
		}

		if (queryResult.recordCount EQ 1) {
			SESSION.loginData.logged = 1;
			SESSION.loginData.ID = queryResult.ID[1];
			SESSION.loginData.username = queryResult.username[1];
	        SESSION.loginData.firstName = queryResult.firstName[1];
	        SESSION.loginData.lastName = queryResult.lastName[1];
	        SESSION.loginData.email =  queryResult.email[1];
			SESSION.loginData.accessLevel =  queryResult.accessLvl[1];
			SESSION.loginData.error = "";
	        SESSION.loginData.message = "";	

			loginResponse.loginData = queryResult;
			loginResponse.status = "Success";
			loginResponse.message = "Login data retrieved.";
		}
		else {			
			loginResponse.status = "Error";
			loginResponse.message = "The login information entered does not match any user";
		}

		if (structKeyExists(arguments, "rememberMe") AND arguments.rememberMe EQ 1) {
			saveLoginCookie(queryResult.ID[1]);
		}

		return serializeJSON(loginResponse);
	}

	package struct function saveLoginCookie(required integer userID, date expirationDate, string encryptionKey) hint = "Create 'Remember Me' cookie" output = "false" {

		saveCookieResponse = structNew();
		saveCookieResponse.status = "";
		saveCookieResponse.message = "";

		if (structKeyExists(arguments, "userID") AND arguments.userID NEQ 0) {
			userID = arguments.userID;
		}
		else {
			saveCookieResponse.status = "error";
			saveCookieResponse.message = "The user ID parameter was not provided.";
			return saveCookieResponse;
		}

		obfuscatedID = CreateUUID() & ":" & userID & ":" & CreateUUID();

		if (structKeyExists(arguments, "encryptionKey") AND arguments.encryptionKey NEQ "") {
			encryptionKey = arguments.encryptionKey;
		}
		else if (structKeyExists(Application, "encryptionKey") AND Application.encryptionKey NEQ "") {
			encryptionKey = Application.encryptionKey;
		}

		cookieValue = Encrypt(obfuscatedID, encryptionKey, "cfmx_compat", "hex");

		if (NOT structKeyExists(arguments, "expirationDate") OR DateDiff("d",Now(),arguments.expirationDate) LTE 0 ) {
			expirationDate = DateFormat(DateAdd("d", 30, Now()), "MM/DD/YY");
		}
		else {
			expirationDate = DateFormat(arguments.expirationDate, "MM/DD/YY");
		}

		cfcookie (name = "U_ID", value = "#cookieValue#", expires="#expirationDate#", httponly="yes");

		saveCookieResponse.status = "success";
		saveCookieResponse.message = "Cookie saved.";

		return saveCookieResponse;
	}

	remote function deleteLoginCookieJSON() hint = "Delete 'Remember Me' cookie" output = "false" returnFormat = "JSON" {

		deleteCookieResponse = structNew();
		deleteCookieResponse["status"] = "";
		deleteCookieResponse["message"] = "";

		cfcookie(name = "U_ID", expires="now");

		SESSION.loginData.logged = 0;
		SESSION.loginData.ID = 0;
		SESSION.loginData.username = "";
        SESSION.loginData.firstName = "";
        SESSION.loginData.lastName = "";
        SESSION.loginData.email = "";
		SESSION.loginData.accessLevel = 0;
		SESSION.loginData.error = "";

		deleteCookieResponse.status = "Success";
		deleteCookieResponse.message = "Cookie deleted";

		return serializeJSON(deleteCookieResponse);
	}

	public function detectLoginCookie(string datasource, string encryptionKey) output = "false" {

		detectCookieResponse = structNew();
		detectCookieResponse["status"] = "";
		detectCookieResponse["message"] = "";
		detectCookieResponse["loginInfo"] = "";

		if (structKeyExists(arguments, "datasource") AND arguments.datasource NEQ "") {
			dsn = arguments.datasource;
		}
		else if(structKeyExists(Application, "dsn") AND Application.dsn NEQ "") {
			dsn = Application.dsn;
		}
		else {
			detectCookieResponse.status = "Error";
			detectCookieResponse.message = "The data source was not provided as an argument, nor is defined in Application.cfc";
			return detectCookieResponse;
		}

		if (structKeyExists(arguments, "encryptionKey") AND arguments.ecryptionKey NEQ "") {
			encryptionKey = arguments.encryptionKey;
		}
		else if (structKeyExists(Application, "encryptionKey") AND Application.encryptionKey NEQ "") {
			encryptionKey = Application.encryptionKey;
		}

		if (structKeyExists(COOKIE,"U_ID")) {
			cookieValue = Decrypt(COOKIE.U_ID, encryptionKey, "cfmx_compat", "hex");
			cookieUserID = ListGetAt(cookieValue, 2, ":");

			loginQuery = new Query();
			loginQuery.setDatasource(dsn);
			loginQuery.setSQL("
				SELECT users.ID, users.username, users.firstName, users.lastName, users.email, access.accessLvl
				FROM users
				LEFT JOIN access ON access.userID = users.ID
				WHERE users.ID = #cookieUserID#
			");

			try {
				queryResponse = loginQuery.execute();
			}
			catch (database e) {
				detectCookieResponse.status = "Error";
				detectCookieResponse.message = "Database error! " & e.detail & cookieUserID;
				return detectCookieResponse;
			}

			detectCookieResponse.status = "Success";
			detectCookieResponse.message = "Cookie detected";
			detectCookieResponse.loginInfo = queryResponse.getResult();
		}
		else {
			detectCookieResponse.status = "Error";
			detectCookieResponse.message = "No cookie detected";
		}

		return detectCookieResponse;
	}

}