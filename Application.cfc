/*
* Created by bit15, 2018
*/

component output="false" {
    /*
    Application variables https://wikidocs.adobe.com/wiki/display/coldfusionen/Application+variables
    */
    this.name = "flyvalle_" & hash(getCurrentTemplatePath());
    this.appBasePath = getDirectoryFromPath(getCurrentTemplatePath());
    this.applicationTimeout = createTimeSpan(0,1,0,0);
    this.clientManagement = false;
    this.clientStorage = "cookies";
    this.loginStorage = "session";
    this.sessionManagement = true;
    this.sessionTimeout = createTimeSpan(0,0,30,0);
    this.setClientCookies = true;
    this.setDomainCookies = false;
    this.secureJSON = false;
    this.secureJSONPrefix = "";
    this.welcomeFileList = "";

    /* Mappings */
    this.mappings["/root"] = this.appBasePath;

    /*
    onApplicationStart https://wikidocs.adobe.com/wiki/display/coldfusionen/onApplicationStart First function run when ColdFusion receives the first request for a page in the application.
    */
    public boolean function onApplicationStart() {
   		Application.domain = "flyvalle.com";
   		Application.dsn = "flyvalle_db";
   		Application.activeSessions = 0;
   		Application.encryptionKey = "fly_F0r3v3r";
        Application.registrationEmail = "mailadmin@" & Application.domain;
        Application.contactEmail = "contact@" & Application.domain;

        // Get full metadata info
        getMeta = createObject("component", "cfc.metadata");
        metaData = getMeta.getMetadata("all");

        if(metaData.status EQ "Success") {
            Application.metadata = metaData.metadata;
        }

        getCountryList = CreateObject("component","cfc.restCountries_ws");
        countryList = getCountryList.countryListCall();
        Application.countryList = countryList.response;

        return true;
    }

    /*
        onApplicationEnd https://wikidocs.adobe.com/wiki/display/coldfusionen/onApplicationEnd Last function run when Application times out or server is shut down.
    */
    public void function onApplicationEnd(struct appScope={}) {
        return;
    }

    /*
    onSessionStart https://wikidocs.adobe.com/wiki/display/coldfusionen/onSessionStart Run when first setting up a session.
    */
    public void function onSessionStart() {
        Application.activeSessions = Application.activeSessions + 1;
   		SESSION.started = createODBCDateTime(Now());
		SESSION.user = StructNew();
		SESSION.user.IP = CGI.REMOTE_ADDR;
		SESSION.user.countryName = "";
		SESSION.user.countryCode = "";
        SESSION.user.regionCode = "";
        SESSION.user.regionName = "";
        SESSION.user.latitude = "";
        SESSION.user.longitude = "";
		SESSION.user.userAgent = CGI.http_user_agent;
		SESSION.user.referer = CGI.http_referer;
		SESSION.loginData = StructNew();
		SESSION.loginData.logged = 0;
		SESSION.loginData.ID = 0;
		SESSION.loginData.username = "";
        SESSION.loginData.firstName = "";
        SESSION.loginData.lastName = "";
        SESSION.loginData.email = "";
		SESSION.loginData.accessLevel = 0;
		SESSION.loginData.error = "";
        SESSION.loginData.message = "";
		SESSION.openWeather = StructNew();
        SESSION.openWeather.key = "897e10d58f8b66bfbe6800ff85007a2d"; /* https://home.openweathermap.org/api_keys */
        SESSION.openWeather.cityID = 3980621; /* Valle de Bravo ID: 3980621 */
        SESSION.openWeather.units = "imperial"; // imperial (Farenheit, miles/hour, mm) | metric (Celsius, m/sec)
        SESSION.openWeather.response = "";
		SESSION.geoLocation = StructNew();

		/* Get weather info for Valle de Bravo */
		if (structKeyExists(SESSION.openWeather, "key") AND SESSION.openWeather.key NEQ "" AND structKeyExists(SESSION.openWeather, "cityID") AND SESSION.openWeather.cityID NEQ "") {
			openWeather = CreateObject("component","cfc.openWeather");
			SESSION.openWeather.response = openWeather.openWeatherCall(SESSION.openWeather.cityID, SESSION.openWeather.key, SESSION.openWeather.units);
		}

		/* Get location of user by IP address */
		if (structKeyExists(SESSION.user, "IP") AND SESSION.user.IP NEQ "") {
			getLocation = createObject("component","cfc.geoPlugin");
			SESSION.geoLocation = getLocation.geoPluginCall(SESSION.user.IP);
            SESSION.user.countryCode = SESSION.geoLocation.response.geoplugin_countryCode;
            SESSION.user.countryName = SESSION.geoLocation.response.geoplugin_countryName;
            SESSION.user.regionCode = SESSION.geoLocation.response.geoplugin_regionCode;
            SESSION.user.regionName = SESSION.geoLocation.response.geoplugin_regionName;
            SESSION.user.latitude = SESSION.geoLocation.response.geoplugin_latitude;
            SESSION.user.longitude = SESSION.geoLocation.response.geoplugin_longitude;
		}

		/* Check for cookie for user login */
        loginUsingCookie = CreateObject("component","cfc.login");
        cookieLogin = loginUsingCookie.detectLoginCookie();

        if(cookieLogin.status EQ "Success") {
            SESSION.loginData.logged = 1;
            SESSION.loginData.ID = cookieLogin.loginInfo.ID;
            SESSION.loginData.username = cookieLogin.loginInfo.username;
            SESSION.loginData.firstName = cookieLogin.loginInfo.firstName;
            SESSION.loginData.lastName = cookieLogin.loginInfo.lastName;
            SESSION.loginData.email = cookieLogin.loginInfo.email;
            SESSION.loginData.accessLevel = cookieLogin.loginInfo.accessLvl;
        }

        return;
    }

    /*
    onSessionEnd https://wikidocs.adobe.com/wiki/display/coldfusionen/onSessionEnd Run when a session ends.
    */
    public function onSessionEnd(required struct sessionScope, struct appScope={}) {

		sessionData = structNew();
		sessionData = {
			"UserIP" = arguments.sessionScope.user.IP,
			"LoginData.ID" = arguments.sessionScope.LoginData.ID,
			"LoginData.Name" = arguments.sessionScope.LoginData.username,
			"UserCountryCode" = arguments.sessionScope.user.countryCode,
            "UserCountryName" = arguments.sessionScope.user.countryName,
            "UserRegionCode" = arguments.sessionScope.user.regionCode,
            "UserRegionName" = arguments.sessionScope.user.regionName,
            "UserLatitude" = arguments.sessionScope.user.latitude,
            "UserLongitude" = arguments.sessionScope.user.longitude,
			"Started" = arguments.sessionScope.started,
			"applicationName" = arguments.appScope.applicationName,
			"URLToken" = arguments.sessionScope.URLToken,
			"UserAgent" = arguments.sessionScope.user.userAgent,
			"Referer" = arguments.sessionScope.user.referer
		};

		saveSession = createObject("component","cfc.saveSessionData");
		insertData = saveSession.insertSessionData(appScope.dsn, sessionData);

        appScope.activeSessions = appScope.activeSessions - 1;

    	return;
    }

    /*
    onRequestStart https://wikidocs.adobe.com/wiki/display/coldfusionen/onRequestStart First page-processing function run when a page request starts.
    Return False to prevent ColdFusion from processing the request.
    */
    public boolean function onRequestStart(required string targetPage) {

    	setting enablecfoutputonly = "false" requesttimeout = "0" showdebugoutput = "true";

		local = {}; // Define the local scope.
		local.basePath = this.appBasePath; // Root folder path (Path to the folder this template is located)
    	local.targetPath = getDirectoryFromPath(expandPath(arguments.targetPage)); // Get the target (script_name) directory path based on expanded script name.
		local.requestDepth = (listLen( local.targetPath, "\/" ) - listLen( local.basePath, "\/" )); // Difference in path
		request.webRoot = repeatString("../", local.requestDepth); // Relative path to root of the requested template 
		request.CurrentTemplate = ListLast(targetPage, "/"); // Current template name

        // Validate registration Email
        if(structKeyExists(URL, "validate_email") AND structKeyExists(URL, "challenge") AND len(URL.challenge) GT 16 ) {

            challengeCode = URL.challenge;

            validateCFC = createObject("component", "cfc.registration");
            validateCFC.validateEmail(challengeCode);
        }

        return true;
    }

    /*
    onRequest https://wikidocs.adobe.com/wiki/display/coldfusionen/onRequest Runs when a request starts, after the onRequestStart event handler.
    This method is optional. If you implement this method, it must explicitly call the requested page to process it.
    */
    public void function onRequest(required string targetPage) {

    	SESSION.actualPage = listLast(Arguments.targetPage, '/');

        include arguments.targetPage;
        
        return;
    }

    /*
        onCFCRequest https://wikidocs.adobe.com/wiki/display/coldfusionen/onCFCRequest Intercepts any HTTP or AMF calls to an application based on CFC request.
        Whereas onRequest handles only requests made to ColdFusion templates, this function controls Ajax, Web Service, and Flash Remoting requests.
    */
    public any function onCFCRequest(string cfcname, string method, struct args) {

        result = invoke(cfcname, method, args);

        return result;
    }

    /*
        onRequestEnd https://wikidocs.adobe.com/wiki/display/coldfusionen/onRequestEnd Runs at the end of a request, after all other CFML code.
    */
    public void function onRequestEnd() {
        return;
    }

    /*
        onAbort https://wikidocs.adobe.com/wiki/display/coldfusionen/onAbort Runs when you execute the CFML tag cfabort or cfscript "abort".
        If showError attribute is specified in cfabort, onError method is executed instead of onAbort.
        When using cfabort, cflocation, or cfcontent tags, the onAbort method is invoked instead on onRequestEnd.
    */
    public void function onAbort(required string targetPage) {
        return;
    }

    /*
        onError https://wikidocs.adobe.com/wiki/display/coldfusionen/onError Runs when an uncaught exception occurs in the application.
        This method overrides any error handlers that you set in the ColdFusion Administrator or in cferror tags. It does not override try/catch blocks.
    */
    public void function onError(required any exception, required string eventName) {

    		writeDump(arguments.exception);
    }

    /*
        onMissingTemplate https://wikidocs.adobe.com/wiki/display/coldfusionen/onMissingTemplate Runs when a request specifies a non-existent CFML page.
        True, or no return value, specifies that the event has been processed. If the function returns false, ColdFusion invokes the standard error handler.
    */
    public boolean function onMissingTemplate(required string targetPage) {
        return true;
    }

}