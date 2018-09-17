/*
* Created by bit15, 2017
* city list: http://openweathermap.org/help/city_list.txt
*/

component output = false hint = "Open Weather service http call" {

	public function init()	{
		return(this);
	}

	public function openWeatherCall(required string cityID, required string key, string units) {
		var openWeather = structNew();
		openWeather.key = arguments.key;
		openWeather.cityID = arguments.cityID;
		if(structKeyExists(arguments, "units")) {
			openWeather.units = arguments.units;
		}
		else {
			openWeather.units = "metric";
		}
		openWeather.status = "";
		openWeather.errorMessage = "";
		
		openWeather.URI = "http://api.openweathermap.org/data/2.5/weather?id=" & openWeather.cityID & "&units=" & openWeather.units & "&appid=" & openWeather.key;
		openWeather.error = "";
		openWeather.icons = {
			"01d" = "wi-day-sunny",
			"01n" = "wi-night-clear",
			"02d" = "wi-day-cloudy",
			"02n" = "wi-night-alt-cloudy",
			"03d" = "wi-cloud",
			"03n" = "wi-cloud",
			"04d" = "wi-cloudy",
			"04n" = "wi-cloudy",
			"09d" = "wi-day-showers",
			"09n" = "wi-night-alt-showers",
			"10d" = "wi-day-rain",
			"10n" = "wi-night-alt-rain",
			"11d" = "wi-day-thunderstorm",
			"11n" = "wi-night-thunderstorm",
			"13d" = "wi-day-snow",
			"13n" = "wi-night-alt-snow",
			"50d" = "wi-day-fog",
			"50n" = "wi-night-fog",
			"temp" = "wi-thermometer",
			"pressure" = "wi-barometer",
			"humidity" = "wi-humidity",
			"sunrise" = "wi-sunrise",
			"sunset" = "wi-sunset",
			"cloud" = "wi-cloud"
		};
		openWeather.data = "";

		try {
			cfhttp(method = "get", url = "#openWeather.URI#", result = "weatherData");
			openWeather.data = DeserializeJSON(weatherData.filecontent);
		}
		catch (any e) {
			writeOutput("Error! Connection with openweather was not established." & e.message);
			openWeather.status = "Error";
			openWeather.error = e.json;
			openWeather.errorMessage = "Error! Connection with http://services.groupkt.com was not established. " & e.message;

			return openWeather;
		};
		for(i = 1; i <= arrayLen(openWeather.data.weather); i++) {
			structInsert(openWeather.data.weather[i], "icon_wi", openWeather.icons[openWeather.data.weather[i].icon], true);
			if(findNoCase("day", openWeather.data.weather[i].icon_wi)) {
				structInsert(openWeather.data.weather[i], "icon_wi_bgcolor", "2fafef", true);
			}
			else if(findNoCase("night", openWeather.data.weather[i].icon_wi)) {
				structInsert(openWeather.data.weather[i], "icon_wi_bgcolor", "14386a", true);
			}
			else {
				structInsert(openWeather.data.weather[i], "icon_wi_bgcolor", "45637a", true);
			}
		}
		
		if(openWeather.units EQ "metric") {
			structInsert(openWeather.data.main, "temp_unit", "&deg;C", true);
		}
		else if(openWeather.units EQ "imperial") {
			structInsert(openWeather.data.main, "temp_unit", "&deg;F", true);
		}
		else {
			structInsert(openWeather.data.main, "temp_unit", "K", true);
		}
		windDir = Round(openWeather.data.wind.deg);
		windIcon = "wi-wind from-" & windDir & "-deg";
		if(openWeather.units EQ "imperial") {
			structInsert(openWeather.data.wind, "speed_unit", "mi/h", true);
		}
		else {
			structInsert(openWeather.data.wind, "speed_unit", "m/sec", true);
		}
		if (windDir GTE 348.75 OR windDir LT 11.25) {
			cardinalDir = "North,N";
		}
		else if (windDir GTE 11.25 AND windDir LT 33.75) {
			cardinalDir = "North-Northeast,NNE";
		}
		else if (windDir GTE 33.75 AND windDir LT 56.25) {
			cardinalDir = "Northeast,NE";
		}
		else if (windDir GTE 56.25 AND windDir LT 78.75) {
			cardinalDir = "East-Northeast,ENE";
		}
		else if (windDir GTE 78.75 AND windDir LT 101.25) {
			cardinalDir = "East,E";
		}
		else if (windDir GTE 101.25 AND windDir LT 123.75) {
			cardinalDir = "East-Southeast,ESE";
		}
		else if (windDir GTE 123.75 AND windDir LT 146.25) {
			cardinalDir = "Southeast,SE";
		}
		else if (windDir GTE 146.25 AND windDir LT 168.75) {
			cardinalDir = "South-Southeast,SSE";
		}
		else if (windDir GTE 168.75 AND windDir LT 191.25) {
			cardinalDir = "South,S";
		}
		else if (windDir GTE 191.25 AND windDir LT 213.75) {
			cardinalDir = "South-Southwest,SSW";
		}
		else if (windDir GTE 213.75 AND windDir LT 236.25) {
			cardinalDir = "Southwest,SW";
		}
		else if (windDir GTE 236.25 AND windDir LT 258.75) {
			cardinalDir = "West-Southwest,Wsw";
		}
		else if (windDir GTE 258.75 AND windDir LT 281.25) {
			cardinalDir = "West,W";
		}
		else if (windDir GTE 281.25 AND windDir LT 303.75) {
			cardinalDir = "West-Northwest,WNW";
		}
		else if (windDir GTE 303.75 AND windDir LT 326.25) {
			cardinalDir = "Northwest,NW";
		}
		else if (windDir GTE 326.25 AND windDir LT 348.75) {
			cardinalDir = "North-Northwest,NNW";
		}
		else {
			cardinalDir = "undefined";
		}
		
		windMessage = openWeather.data.wind.speed & openWeather.data.wind.speed_unit & " from " & listFirst(cardinalDir) & " (" & windDir & "&deg; " & uCase(listLast(cardinalDir)) & ")";

		structInsert(openWeather.data.main, "humidity_icon", openWeather.icons["humidity"], true);
		structInsert(openWeather.data.main, "pressure_icon", openWeather.icons["pressure"], true);
		structInsert(openWeather.data.main, "temp_icon", openWeather.icons["temp"], true);
		structInsert(openWeather.data.sys, "sunrise_icon", openWeather.icons["sunrise"], true);
		sunriseLocalTime = convertUnixTimeStamp(openWeather.data.sys.sunrise);
		structInsert(openWeather.data.sys, "sunrise_lt", sunriseLocalTime, true);
		structInsert(openWeather.data.sys, "sunset_icon", openWeather.icons["sunset"], true);
		sunsetLocalTime = convertUnixTimeStamp(openWeather.data.sys.sunset);
		structInsert(openWeather.data.sys, "sunset_lt", sunsetLocalTime, true);
		structInsert(openWeather.data.wind, "wind_icon", windIcon, true);
		structInsert(openWeather.data.wind, "wind_message", windMessage, true);
		structInsert(openWeather.data.clouds, "clouds_icon", openWeather.icons["cloud"], true);

		openWeather.status = "success";

		return openWeather;
	}

	public function convertUnixTimeStamp (required numeric epochTimestamp) {

		if (isvalid("integer", epochTimestamp)) {
			d = DateAdd("s", epochTimestamp, DateConvert("utc2Local", "January 1 1970 00:00"));
		} else if (isnumeric(epochTimestamp) AND VAL(epochTimestamp) GT 1000) {
			d = DateAdd("s", epochTimestamp/1000, DateConvert("utc2Local", "January 1 1970 00:00"));
		}

		return d;
	}
}