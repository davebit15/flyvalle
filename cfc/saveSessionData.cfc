/*
* Created by bit15, 2017
*/

component output = false hint = "Save data from session in database" {

	public function insertSessionData(required string datasource, required struct sessionData) {

		insertData = new Query();
		insertData.setDatasource(arguments.datasource);
		insertData.setSQL("
			INSERT INTO stats (	sessionUserIP,
								sessionUserID,
								sessionUserName,
								sessionUserCountryCode,
								sessionUserCountryName,
								sessionUserRegionCode,
								sessionUserRegionName,
								sessionUserLatitude,
								sessionUserLongitude,
								sessionStartTime,
								sessionEndTime,
								sessionAppName,
								sessionURLToken,
								sessionUserAgent,
								sessionReferer)
						VALUES(	'#arguments.sessionData.UserIP#',
								#arguments.sessionData.LoginData.ID#,
								'#arguments.sessionData.LoginData.Name#',
								'#arguments.sessionData.UserCountryCode#',
								'#arguments.sessionData.UserCountryName#',
								'#arguments.sessionData.UserRegionCode#',
								'#arguments.sessionData.UserRegionName#',
								'#arguments.sessionData.UserLatitude#',
								'#arguments.sessionData.UserLongitude#',
								#arguments.sessionData.Started#,
								#CreateODBCDateTime(Now())#,
								'#arguments.sessionData.applicationName#',
								'#arguments.sessionData.URLToken#',
								'#arguments.sessionData.UserAgent#',
								'#arguments.sessionData.Referer#')
		");
		try {
			insertResult = insertData.execute();
		}
		catch (any e) {

		}
	}

}