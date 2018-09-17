<cfswitch expression="#SESSION.loginData.accessLevel#">

	<cfcase value="2">
		
		<!DOCTYPE html>
		<html lang="en">

		<head>
		    <meta charset="UTF-8">
		    <meta name="viewport" content="width=device-width, initial-scale=1">
		    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">

		    <title>flyvalle</title>

			<cfoutput>

			    <link rel="apple-touch-icon" sizes="180x180" href="#request.webRoot#assets/img/apple-touch-icon.png">
			    <link rel="icon" type="image/png" sizes="32x32" href="#request.webRoot#assets/img/favicon-32x32.png">
			    <link rel="icon" type="image/png" sizes="16x16" href="#request.webRoot#assets/img/favicon-16x16.png">
			    <link rel="manifest" href="#request.webRoot#assets/img/site.webmanifest">
			    <link rel="mask-icon" href="#request.webRoot#assets/img/safari-pinned-tab.svg" color="##5bbad5">
			    <link rel="shortcut icon" href="#request.webRoot#assets/img/favicon.ico">
			    <meta name="msapplication-TileColor" content="##da532c">
			    <meta name="msapplication-config" content="/assets/img/browserconfig.xml">
			    <meta name="theme-color" content="##ffffff">
			    <meta name="description" content="">

			    <!-- CSS -->
			    <link href="#request.webRoot#assets/css/preload.css" rel="stylesheet">
			    <link href="#request.webRoot#assets/css/vendors.css" rel="stylesheet">
			    <link href="#request.webRoot#assets/css/syntaxhighlighter/shCore.css" rel="stylesheet" >

			    <link href="#request.webRoot#assets/css/style-fv.css" rel="stylesheet" title="default">
			    <link href="#request.webRoot#assets/css/width-full.css" rel="stylesheet" title="default">

			    <link href="#request.webRoot#assets/css/AdminLTE.css" rel="stylesheet" title="default">
			    <link href="#request.webRoot#assets/css/jquery-jvectormap-2.0.3.css" rel="stylesheet" title="default">
				<!-- DataTables -->
				<link rel="stylesheet" href="#request.webRoot#assets/datatables.net-bs/css/dataTables.bootstrap.min.css">

				<!-- bootstrap wysihtml5 - text editor -->
				<link rel="stylesheet" href="#request.webRoot#assets/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css">

			    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
			    <!--[if lt IE 9]>
			        <script src="#request.webRoot#assets/js/html5shiv.min.js"></script>
			        <script src="#request.webRoot#assets/js/respond.min.js"></script>
			    <![endif]-->

			</cfoutput>
			

		</head>

		<!-- Preloader -->
		<div id="preloader">
		    <div id="status">&nbsp;</div>
		</div>

		<body>

		    <div class="sb-site-container">

		        <div class="boxed">

		            <cfscript>
		                /* HEADER ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
		                include "/root/header.cfm";
		                /* HEADER ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */

		                /* TOP NAVIGATION ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
		                include "/root/admin/navbar-top.cfm";
		                /* TOP NAVIGATION ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */

		                /* CONTENT |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
		                include "/root/admin/admin-articles.cfm";
		                /* CONTENT |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */

		                /* FOOTER ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
		                include "/root/footer.cfm";
		                /* FOOTER ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
		            </cfscript>

		        </div> <!-- boxed -->

		    </div> <!-- sb-site -->

		    <div id="back-top">
		        <a href="#header"><i class="fa fa-chevron-up"></i></a>
		    </div>

		    <!-- Scripts -->
			<cfoutput>
			    <script src="#request.webRoot#assets/js/vendors.js"></script>

			    <!-- Syntaxhighlighter -->
			    <script src="#request.webRoot#assets/js/syntaxhighlighter/shCore.js"></script>
			    <script src="#request.webRoot#assets/js/syntaxhighlighter/shBrushXml.js"></script>
			    <script src="#request.webRoot#assets/js/syntaxhighlighter/shBrushJScript.js"></script>
				<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.min.js"></script>
			    <script src="#request.webRoot#assets/js/jquery-jvectormap-2.0.3.min.js"></script>
			    <script src="#request.webRoot#assets/js/jquery-jvectormap-world-mill.js"></script>

			    <script src="#request.webRoot#assets/js/DropdownHover.js"></script>
			    <script src="#request.webRoot#assets/js/app.js"></script>
			    <script src="#request.webRoot#assets/js/holder.js"></script>
			    <script src="#request.webRoot#assets/js/home_info.js"></script>
			    <script src="#request.webRoot#assets/js/flyvalle.js"></script>
			    <script src="#request.webRoot#assets/js/registration.js"></script>
				<script src="#request.webRoot#assets/js/login.js"></script>
				<!-- DataTables -->
				<script src="#request.webRoot#assets/datatables.net-bs/js/jquery.dataTables.min.js"></script>
				<script src="#request.webRoot#assets/datatables.net-bs/js/dataTables.bootstrap.min.js"></script>
				<!-- Bootstrap WYSIHTML5 -->
				<script src="#request.webRoot#assets/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"></script>
			</cfoutput>

			<!--- Initialize Data Tables, WYSIHTML5 editor --->
			<script>
				//data tables
				$(function () {
					$('#articles-table').DataTable({
						'paging'      : true,
						'lengthChange': true,
						'searching'   : true,
						'ordering'    : true,
						'info'        : false,
						'autoWidth'   : true,
						'columnDefs': [
							{ 'orderable': false, 'targets': 4 }
						]
					})
				});
				//WYSIHTML5
				$(function () {
					$('#article-body, #article-synopsis').wysihtml5({
						toolbar: {
							'image': false,
							'link': false,
							'html': true
						}
					})
				});
				//Datemask dd/mm/yyyy
    			//$('#datemask').inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' });
			</script>
			
		</body>

		</html>

	</cfcase>

	<cfdefaultcase>
	
		<cflocation url="../login.cfm" addtoken="false" />

	</cfdefaultcase>

</cfswitch>