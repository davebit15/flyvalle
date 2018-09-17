component accessors = false output = false persistent = false {

	public function init()	{
		return(this);
	}

	public function getMetadata (string template, string datasource) {

		metadataResponse = structNew();
		metadataResponse["status"] = "";
		metadataResponse["message"] = "";
		metadataResponse["metadataData"] = "";

		if(structKeyExists(arguments, "template") AND arguments.template IS NOT "") {
			template = arguments.template;
		}
		else {
			template = "global";
		}

		if(structKeyExists(arguments, "datasource") AND arguments.datasource IS NOT "") {
			dsn = arguments.datasource;
		}
		else if(structKeyExists(Application, "dsn") AND Application.dsn IS NOT "") {
			dsn = Application.dsn;
		}
		else {
			metadataResponse.status = "Error";
			metadataResponse.message = "The datasource is not defined";
			return metadataResponse;
		}

		metadataQuery = new Query();
		metadataQuery.setDatasource(dsn);

		if(template EQ "all") {
			metadataQuery.setSQL("
				SELECT *
				FROM metadata
			");
		}
		else {
			metadataQuery.setSQL("
				SELECT *
				FROM metadata
				WHERE template = '#template#'
			");			
		}

		try {
			queryResponse = metadataQuery.execute();
			queryResult = queryResponse.getResult();
		}
		catch (database e) {
			metadataResponse.status = "Error";
			metadataResponse.message = "Database error! " & e;
			return metadataResponse;
		}

		if(queryResult.recordCount GT 0) {
			metadataResponse.status = "Success";
			metadataResponse.message = "Metadata information retrieved";
			metadataResponse.metadata = queryResult;
		}

		return metadataResponse;
	}

}