/*
* Created by bit15, 2018
*/

component accessors = false output = false persistent = false {

	public function getSocialMediaData(string datasource) output = "false" {

		smResponse["status"] = "";
		smResponse["message"] = "";
		smResponse["data"] = "";

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
			smResponse.status = "Error";
			smResponse.message = "Valid datasource value was not provided";
			return smResponse;
		}

		getSM = new Query();
		getSM.setDatasource(datasource);
		getSM.setSQL("
			SELECT *
			FROM socialmedia
			WHERE name IS NOT NULL AND name != ''
		");

		try {
			getSMData = getSM.execute();
		}
		catch(any e) {
			smResponse.status = "Error";
			smResponse.message = "Query error";
			smResponse.data = e;

			return smResponse;
		}

		smResponse.status = "Success";
		smResponse.message = "Visitors data retrieved";
		smResponse.data = getSMData.getResult();

		return smResponse;
	}

}