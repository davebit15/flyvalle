/*
* Created by bit15, 2018
* https://restcountries.eu
*/

component accessors = true output = false persistent = false hint = "Countries info" {

	restCountriesURL = "https://restCountries.eu/";

	public struct function countryListCall() output = "false" hint = "Returns list of all countries with ISO-2 and ISO-3 country codes"{
		var restCountries = structNew();
		restCountries.URI = restCountriesURL & "rest/v2/all";
		restCountries.response = "";
		restCountries.error = "";

		try {
			cfhttp(method = "get", url = "#restCountries.URI#", result = "countryList");
			restCountries.response = DeserializeJSON(countryList.filecontent);
		}
		catch (any e) {
			restCountries.error = "Error! Connection with " & restCountries.URI & " failed ("  & e.message & ").";
		}

		return restCountries;
	}

	public struct function getCountryByCodeCall(required string countryISO) output = "false" hint = "Returns info for the given country ISO code (two or three letter)" {
		var restCountryInfo = structNew();
		restCountryInfo.URI = restCountriesURL & "rest/v2/alpha/" & arguments.countryISO;
		restCountryInfo.response = "";
		restCountryInfo.error = "";

		try {
			cfhttp(method = "get", url = "#restCountryInfo.URI#", result = "stateList");
			restCountryInfo.response = DeserializeJSON(stateList.filecontent);
		}
		catch (any e) {
			restCountryInfo.error = "Error! Connection with " & restCountryInfo.URI & " failed ("  & e.message & ").";
		}

		return restCountryInfo;
	}

}