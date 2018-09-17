/*
* Created by bit15, 2017
* http://www.geoplugin.com
* http://www.geoplugin.com/webservices/json
*/

component accessors = true output = false persistent = false hint = "IP geo-location service" {

	public struct function geoPluginCall(required string userIP) output = "false" {
		var geoPlugin = structNew();
		geoPlugin.userIP = arguments.userIP;
		geoPlugin.URL = "http://www.geoplugin.net/json.gp?ip=";
		geoPlugin.URI = geoPlugin.URL & geoPlugin.userIP;
		geoPlugin.response = "";
		geoPlugin.error = "";

		try {
			cfhttp(method = "get", url = "#geoPlugin.URI#", result = "geolocation");
			geoPlugin.response = DeserializeJSON(geolocation.filecontent);
		}
		catch (any e) {
			geoPlugin.error = "Error! Connection with " & geoPlugin.URI & " using IP " & arguments.userIP & " failed.";
		}

		return geoPlugin;
	}

}