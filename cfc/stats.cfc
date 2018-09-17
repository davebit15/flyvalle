/*
* Created by bit15, 2018
*/

component accessors = false output = false persistent = false {

	public function getVisitorsData(string timeframe, string datasource, date startDate, date endDate) output = "false" {

		statsResponse["status"] = "";
		statsResponse["message"] = "";
		statsResponse["data"] = "";

		if (structKeyExists(arguments, "endDate") AND arguments.endDate NEQ "") {
			endDate = createODBCDate(arguments.endDate);
		}
		else {
			endDate = createODBCDate(dateAdd("d", 1, now()));
		}

		if (structKeyExists(arguments, "startDate") AND arguments.startDate NEQ "") {
			startDate = createODBCDate(startDate);
		}
		else {
			if (structKeyExists(arguments, "timeframe") AND arguments.timeframe EQ "week") {
				startDate = createODBCDate(dateAdd("ww", -1, endDate));
			}
			else if (structKeyExists(arguments, "timeframe") AND arguments.timeframe EQ "month") {
				startDate = createODBCDate(dateAdd("m", -1, endDate));
			}
			else {
				startDate = createODBCDate(dateAdd("yyyy", -1, endDate));
			}			
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
			statsResponse.status = "Error";
			statsResponse.message = "Valid datasource value was not provided";
			return statsResponse;
		}

		getStats = new Query();
		getStats.setDatasource(datasource);
		getStats.setSQL("
			SELECT count(*) AS visitors,sessionUserIP,sessionUserCountryCode,sessionUserCountryName,DATE_FORMAT(sessionStartTime,'%Y-%m-%d') AS visitDay,sessionEndTime,sessionUserAgent,sessionReferer
			FROM stats
			WHERE sessionStartTime >= #startDate# AND sessionStartTime <= #endDate#
			GROUP BY visitDay
			ORDER BY visitDay
		");

		try {
			statsData = getStats.execute();
		}
		catch(any e) {
			statsResponse.status = "Error";
			statsResponse.message = "Query error";
			statsResponse.data = e;

			return statsResponse;
		}

		statsResponse.status = "Success";
		statsResponse.message = "Visitors data retrieved";
		statsResponse.data = statsData.getResult();

		return statsResponse;
	}

	public function getNewRegistrations(string timeframe, string datasource) output = "false" {

		statsResponse["status"] = "";
		statsResponse["message"] = "";
		statsResponse["data"] = "";

		endDate = createODBCDate(dateAdd("d", 1, now()));

		if (structKeyExists(arguments, "timeframe") AND arguments.timeframe EQ "week") {
			startDate = createODBCDate(dateAdd("ww", -1, endDate));
		}
		else if (structKeyExists(arguments, "timeframe") AND arguments.timeframe EQ "month") {
			startDate = createODBCDate(dateAdd("m", -1, endDate));
		}
		else {
			startDate = createODBCDate(dateAdd("yyyy", -1, endDate));
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
			statsResponse.status = "Error";
			statsResponse.message = "Valid datasource value was not provided";
			return statsResponse;
		}

		getNewReg = new Query();
		getNewReg.setDatasource(datasource);
		getNewReg.setSQL("
			SELECT count(*) AS regUsers,DATE_FORMAT(creationDate,'%Y-%m-%d') AS regDay
			FROM users
			WHERE emailVerified = 1 AND creationDate >= #startDate# AND creationDate <= #endDate#
			GROUP BY regDay
			ORDER BY regDay
		");

		try {
			statsData = getNewReg.execute();
		}
		catch(any e) {
			statsResponse.status = "Error";
			statsResponse.message = "Query error";
			statsResponse.data = e;

			return statsResponse;
		}

		statsResponse.status = "Success";
		statsResponse.message = "Registration data retrieved";
		statsResponse.data = statsData.getResult();

		return statsResponse;

	}

	public function getVisitorCountries(string timeframe, string datasource) output = "false" {

		statsResponse["status"] = "";
		statsResponse["message"] = "";
		statsResponse["data"] = "";

		endDate = createODBCDate(dateAdd("d", 1, now()));

		if (structKeyExists(arguments, "timeframe") AND arguments.timeframe EQ "week") {
			startDate = createODBCDate(dateAdd("ww", -1, endDate));
		}
		else if (structKeyExists(arguments, "timeframe") AND arguments.timeframe EQ "month") {
			startDate = createODBCDate(dateAdd("m", -1, endDate));
		}
		else {
			startDate = createODBCDate(dateAdd("yyyy", -1, endDate));
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
			statsResponse.status = "Error";
			statsResponse.message = "Valid datasource value was not provided";
			return statsResponse;
		}

		getVisitCountries = new Query();
		getVisitCountries.setDatasource(datasource);
		getVisitCountries.setSQL("
			SELECT count(*) AS visitors,DATE_FORMAT(sessionStartTime,'%Y-%m-%d') AS visitDay, sessionUserCountryCode AS countryISO, sessionUserCountryName AS country
			FROM stats
			WHERE sessionStartTime >= #startDate# AND sessionStartTime <= #endDate# AND sessionUserCountryCode != '' AND sessionUserCountryName != ''
			GROUP BY country
			ORDER BY visitors DESC
		");

		try {
			statsData = getVisitCountries.execute();
		}
		catch(any e) {
			statsResponse.status = "Error";
			statsResponse.message = "Query error";
			statsResponse.data = e;

			return statsResponse;
		}

		statsResponse.status = "Success";
		statsResponse.message = "Visiting countries data retrieved";
		statsResponse.data = statsData.getResult();

		return statsResponse;
	}

}