/*
* Created by bit15, 2018
*/

component output="false" hint="Convert Unix epoch timestamp to date" {

	public function init()	{
		return(this);
	}

	public function epochToDate(required numeric epochTimestamp) {

		if (isvalid("integer", epochTimestamp)) {
			d = DateAdd("s", epochTimestamp, DateConvert("utc2Local", "January 1 1970 00:00"));
		} else if (isnumeric(epochTimestamp) AND VAL(epochTimestamp) GT 1000) {
			d = DateAdd("s", epochTimestamp/1000, DateConvert("utc2Local", "January 1 1970 00:00"));
		}

		return d;
	}

}