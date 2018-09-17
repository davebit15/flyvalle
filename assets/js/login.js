$(document).ready(function() {

	$("#loginForm").submit(function(event) {

		event.preventDefault();
		
		dataString = $("#loginForm").serialize();

	    $.ajax({
	    	type: "post",
	   		url: "cfc/login.cfc?method=loginUserJSON",
	    	data: dataString,
	    	dataType: "json",
	    	success: function(data) {
				if (data.status == "Error") {
					$('#loginAlert').addClass('alert alert-danger mt-1').show('fast');
					$("#loginAlert").html("Error: " + data.message);
				}
				else {
					location.reload();
				}						      
			},
			error: function (){
				$('#mailListAlert').addClass('alert alert-danger mt-1').show('fast');
				$("#agreement-alert span").html("Error: Connection with the component was not established (username)");
			}
		});
	});

	$("#userLogout, #logoutBtn").click(function(event) {
		
		event.preventDefault();

	    $.ajax({
	    	type: "post",
	   		url: "http://flyvalle.com/cfc/login.cfc?method=deleteLoginCookieJSON",
	    	dataType: "json",
	    	success: function(data) {
				if (data.status == "Success") {
					location.reload();
				}
				else {
					alert("something went wrong");
				}						      
			},
			error: function (){
				alert("network error");
			}
		});

	});

});