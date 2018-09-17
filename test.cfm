<cfscript>

	getArticlesData = CreateObject("component","cfc.articles");
	response = getArticlesData.getArticlesList();


	writeDump(application.metadata);

	//writeOutput(response.articles.title[1]);

</cfscript>