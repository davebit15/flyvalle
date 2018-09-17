/*
	bit15 2017
*/
component accessors = true output = false persistent = false hint = "" {

	public struct function generatePagination(required numeric totalRecords, required numeric selectedPage, required string templatePath, numeric itemsPerPage, numeric pageBtnsToShow, string navSize) output = "false" {

		pagingResponse = structNew();
		pagingResponse.status = "";
		pagingResponse.message = "";
		pagingResponse.maxRows = 1;
		pagingResponse.actualPage = 1;
		pagingResponse.startRow = 1;
		pagingResponse.pagingNav = "";
		pagingResponse.pagingInfo = "";
		pagingResponse.pagingJumpTo = "";

		// itemsPerPage: ITEMS PER PAGE
		if(structKeyExists(arguments, "itemsPerPage") AND arguments.itemsPerPage GT 1) {
			itemsPerPage = arguments.itemsPerPage;
		}
		else {
			itemsPerPage = 24;
		}
		// pageBtnsToShow: PAGE BUTTONS TO SHOW
		if(structKeyExists(arguments, "pageBtnsToShow") AND arguments.pageBtnsToShow GT 1) {
			pageBtnsToShow = arguments.pageBtnsToShow;
		}
		else {
			pageBtnsToShow = 5;
		}
		// navSize: SIZE OF THE NAVIGATION BUTTONS
		if(structKeyExists(arguments, "navSize") AND arguments.navSize NEQ "") {
			navSize = arguments.navSize;
		}
		else {
			navSize = "pagination-sm";
		}
		// totalRecords: TOTAL NUMBER OF RECORDS TO PAGINATE
		if(structKeyExists(arguments, "totalRecords") AND arguments.totalRecords GT 0) {
			totalRecords = arguments.totalRecords;
		}
		else {
			pagingResponse.status = "error";
			pagingResponse.message = "The number of records to paginate was not provided";

			return pagingResponse;
		}
		// selectedPage: 
		if(structKeyExists(arguments, "selectedPage") AND isNumeric(arguments.selectedPage) AND arguments.selectedPage GT 0) {
			selectedPage = arguments.selectedPage;
		}
		else {
			pagingResponse.status = "error";
			pagingResponse.message = "The starting page was not provided";

			return pagingResponse;
		}

		if(structKeyExists(arguments, "templatePath") AND arguments.templatePath NEQ "") {
			path = arguments.templatePath;
		}
		else {
			pagingResponse.status = "error";
			pagingResponse.message = "The path to the paging file was not provided";

			return pagingResponse;
		}

		numberOfPages = ceiling(totalRecords / itemsPerPage);
		buttonsBefore = int(pageBtnsToShow / 2);
		buttonsAfter = pageBtnsToShow - buttonsBefore - 1;

		if(numberOfPages GT pageBtnsToShow) {
			if(selectedPage LTE buttonsBefore) {
				startPage = 1;
				extraBtnRight = buttonsBefore - selectedPage + 1;
			}
			else {
				startPage = selectedPage - buttonsBefore;
				extraBtnRight = 0;
			}
			if(selectedPage GTE numberOfPages - buttonsAfter) {
				endPage = numberOfPages;
				extraBtnLeft = numberOfPages - selectedPage - buttonsAfter;
			}
			else {
				endPage = selectedPage + buttonsAfter;
				extraBtnLeft = 0;
			}
			startPage = startPage + extraBtnLeft;
			endPage = endPage + extraBtnRight;
		}
		else {
			startPage = 1;
			endPage = numberOfPages;
		}

		if(totalRecords GT 0) {
			if(numberOfPages GT 1) {
				if(selectedPage GT 1) {
					previousLink = path & "?start=" & selectedPage - 1;
					previousClass = "";
				}
				else {
					previousLink = "javascript:void(0)";
					previousClass = "disabled";
				};
				if(selectedPage * itemsPerPage LT totalRecords) {
					nextLink = path & "?start=" & selectedPage + 1;
					nextClass = "";
				}
				else {
					nextLink = "javascript:void(0)";
					nextClass = "disabled";
				};
				savecontent variable="pagingResponse.pagingNav" {
					writeOutput('
						<div class="row text-center">
							<ul class="pagination pagination-sm">
								<li class="#previousClass#"><a href="#previousLink#">«</a></li>
					');
					for(i = startPage; i <= endPage; i++) {
						if(selectedPage EQ i) {
							pageClass = "active";
						}
						else {
							pageClass = "";
						}
						writeOutput('<li class="#pageClass#"><a href="#path#?start=#i#">#i#</a></li>');
					}
					writeOutput('
								<li class="#nextClass#"><a href="#nextLink#">»</a></li>
							</ul>
						</div>
					');					
				}			
			}

			if(selectedPage GT 1) {
				pagingResponse.startRow = (selectedPage - 1) * itemsPerPage + 1;
			}
			else {
				pagingResponse.startRow = 1;
			}

			pagingResponse.maxRows = itemsPerPage;
			pagingResponse.actualPage = selectedPage;
			pagingResponse.pagingInfo = '<div class="row text-center"><h5>Showing page ' & selectedPage & ' of ' & numberOfPages & '</h5></div>';
			pagingResponse.status = "success";	
		}

		return pagingResponse;

	}
	/* end function **generatePagination** */

}
/* end component */