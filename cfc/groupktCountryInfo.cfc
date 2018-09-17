/*
* Created by bit15, 2017
* http://www.geoplugin.com
* http://www.geoplugin.com/webservices/json
*/

component accessors = true output = false persistent = false hint = "Countries info" {

	groupktURL = "http://services.groupkt.com/";

	public struct function countryListCall() output = "false" hint = "Returns list of all countries with ISO-2 and ISO-3 country codes"{
		var groupktCountries = structNew();
		groupktCountries.URI = groupktURL & "country/get/all";
		groupktCountries.response = "";
		groupktCountries.error = "";

		try {
			cfhttp(method = "get", url = "#groupktCountries.URI#", result = "countryList");
			groupktCountries.response = DeserializeJSON(countryList.filecontent);
		}
		catch (any e) {
			groupktCountries.error = "Error! Connection with " & groupktCountries.URI & " failed ("  & e.message & ").";
		}

		return groupktCountries;
	}

	public struct function statesListCall(required string countryISO) output = "false" hint = "Returns list of states/provinces/territories for the given country" {
		var groupktStates = structNew();
		groupktStates.URI = groupktURL & "state/get/" & arguments.countryISO & "/all";
		groupktStates.response = "";
		groupktStates.error = "";

		try {
			cfhttp(method = "get", url = "#groupktStates.URI#", result = "stateList");
			groupktStates.response = DeserializeJSON(stateList.filecontent);
		}
		catch (any e) {
			groupktStates.error = "Error! Connection with " & groupktStates.URI & " failed ("  & e.message & ").";
		}

		return groupktStates;
	}

}