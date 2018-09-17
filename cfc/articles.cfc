/*
* Created by bit15, 2018
*/

component output="false" hint="Manage and retrieve articles" {

	public function init()	{
		return(this);
	}

	public function getArticlesList(string datasource, date startDate, date endDate) {

		articlesResponse = structNew();
		articlesResponse["status"] = "";
		articlesResponse["message"] = "";
		articlesResponse["articles"] = "";
		articlesResponse["categories"] = "";

		if(structKeyExists(arguments, "startDate") AND isValid("date", arguments.startDate)) {
			startDate = createODBCDate(arguments.startDate);
		}
		else {
			startDate = createODBCDate(createDate(2018, 01, 01));
		}

		if(structKeyExists(arguments, "endDate") AND isValid("date", arguments.endDate)) {
			endDate = createODBCDate(arguments.endDate);
		}
		else {
			endDate = createODBCDate(now());
		}

		if(structKeyExists(arguments, "datasource") AND arguments.datasource IS NOT "") {
			dsn = arguments.datasource;
		}
		else if(structKeyExists(Application, "dsn") AND Application.dsn IS NOT "") {
			dsn = Application.dsn;
		}
		else {
			articlesResponse.status = "Error";
			articlesResponse.message = "The datasource is not defined";
			return articlesResponse;
		}

		articlesQuery = new Query();
		articlesQuery.setDatasource(dsn);

		articlesQuery.setSQL("
			SELECT articles.ID, articles.title, articles.synopsis, articles.creationDate, articles.modificationDate, articles.body, users.firstName AS authorFName, users.lastName AS authorLName
			FROM articles, users
			WHERE articles.creationDate >= #startDate# AND articles.creationDate <= #endDate# AND users.ID = articles.authorUserID
			ORDER BY articles.ID DESC
		");

		try {
			queryResponse = articlesQuery.execute();
			queryResult = queryResponse.getResult();
		}
		catch (database e) {
			articlesResponse.status = "Error";
			articlesResponse.message = "Database error! " & e;
			return articlesResponse;
		}

		if(queryResult.recordCount GT 0) {
			articlesResponse.status = "Success";
			articlesResponse.message = "Articles information retrieved";
			articlesResponse.articles = queryResult;
		}

		return articlesResponse;
		
	}

}