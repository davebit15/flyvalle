<!DOCTYPE html>
<html lang="en">

<head>
    <cfquery name="getMeta" datasource="Application.metadata" dbtype="query">
        SELECT *
        FROM Application.metadata
        WHERE template = 'global' OR template = 'contact'
    </cfquery>

    <cfoutput query="getMeta">
        <meta 
        <cfif httpequiv NEQ "">
            http-equiv = "#httpequiv#"
        </cfif>
        <cfif charset NEQ "">
            charset = "#charset#"
        </cfif>
        <cfif name NEQ "">
            name = "#name#"
        </cfif>
        <cfif content NEQ "">
            content = "#content#"
        </cfif>
         />
    </cfoutput>

    <title>flyvalle</title>

    <link rel="apple-touch-icon" sizes="180x180" href="/assets/img/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="/assets/img/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/assets/img/favicon-16x16.png">
    <link rel="manifest" href="/assets/img/site.webmanifest">
    <link rel="mask-icon" href="/assets/img/safari-pinned-tab.svg" color="#5bbad5">
    <link rel="shortcut icon" href="/assets/img/favicon.ico">
    <meta name="msapplication-TileColor" content="#da532c">
    <meta name="msapplication-config" content="/assets/img/browserconfig.xml">
    <meta name="theme-color" content="#ffffff">

    <!-- CSS -->
    <link href="assets/css/preload.css" rel="stylesheet">

    <!-- Compiled in vendors.js -->
    <!--
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/bootstrap-switch.min.css" rel="stylesheet">
    <link href="assets/css/font-awesome.min.css" rel="stylesheet">
    <link href="assets/css/animate.min.css" rel="stylesheet">
    <link href="assets/css/slidebars.min.css" rel="stylesheet">
    <link href="assets/css/lightbox.css" rel="stylesheet">
    <link href="assets/css/jquery.bxslider.css" rel="stylesheet" />
    <link href="assets/css/buttons.css" rel="stylesheet">
    -->

    <link href="assets/css/vendors.css" rel="stylesheet">
    <link href="assets/css/syntaxhighlighter/shCore.css" rel="stylesheet" >

    <!-- weather icons -->
    <link href="./assets/weather-icons-master/css/weather-icons.min.css" rel="stylesheet">
    <link href="./assets/weather-icons-master/css/weather-icons-wind.min.css" rel="stylesheet">

    <!-- Leaflet Map CSS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.3.1/dist/leaflet.css" integrity="sha512-Rksm5RenBEKSKFjgI3a41vrjkw4EVPlJ3+OiI65vTjIdo9brlAacEuKOiQ5OFh7cOI1bkDwLqdLw3Zg0cRJAAQ=="crossorigin=""/>

    <!-- RS5.0 Stylesheet -->
    <!--<link rel="stylesheet" type="text/css" href="assets/css/settings.css">
    <link rel="stylesheet" type="text/css" href="assets/css/layers.css">
    <link rel="stylesheet" type="text/css" href="assets/css/navigation.css">-->

    <link href="assets/css/style-fv.css" rel="stylesheet" title="default">
    <link href="assets/css/width-full.css" rel="stylesheet" title="default">

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
        <script src="assets/js/html5shiv.min.js"></script>
        <script src="assets/js/respond.min.js"></script>
    <![endif]-->
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
                include "header.cfm";
                /* HEADER ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */

                /* TOP NAVIGATION ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
                include "navbar-top.cfm";
                /* TOP NAVIGATION ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */

                /* CONTENT |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
                include "contact-form.cfm";
                include "map.cfm";
                /* CONTENT |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */

                /* FOOTER WIDGETS ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
                include "footer-widgets.cfm";
                /* FOOTER WIDGETS ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */

                /* FOOTER ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
                include "footer.cfm";
                /* FOOTER ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
            </cfscript>

        </div> <!-- boxed -->

    </div> <!-- sb-site -->

    <cfscript>
        /* SIDE NAVIGATION |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
        include "sidebar-slide.cfm";
        /* SIDE NAVIGATION |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
    </cfscript>

    <div id="back-top">
        <a href="#header"><i class="fa fa-chevron-up"></i></a>
    </div>

    <!-- Scripts -->
    <!-- Compiled in vendors.js -->
    <!--
    <script src="assets/js/jquery.min.js"></script>
    <script src="assets/js/jquery.cookie.js"></script>
    <script src="assets/js/imagesloaded.pkgd.min.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>
    <script src="assets/js/bootstrap-switch.min.js"></script>
    <script src="assets/js/wow.min.js"></script>
    <script src="assets/js/slidebars.min.js"></script>
    <script src="assets/js/jquery.bxslider.min.js"></script>
    <script src="assets/js/holder.js"></script>
    <script src="assets/js/buttons.js"></script>
    <script src="assets/js/jquery.mixitup.min.js"></script>
    <script src="assets/js/circles.min.js"></script>
    <script src="assets/js/masonry.pkgd.min.js"></script>
    <script src="assets/js/jquery.matchHeight-min.js"></script>
    -->

    <!--- Leaflet Map Javascript --->
    <!--- https://leafletjs.com/reference-1.3.0.html --->
    <script src="https://unpkg.com/leaflet@1.3.1/dist/leaflet.js" integrity="sha512-/Nsx9X4HebavoBvEBuyp3I7od5tA0UzAxs+j83KgC8PU0kgB4XiK4Lfe4y4cgBtaRJQEIFCW+oC506aPT2L1zw=="crossorigin=""></script>

    <script type="text/javascript">
        var map = L.map('map').setView([19.19, -100.13], 16);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(map);
        var myIcon = L.icon({
            iconUrl: 'assets/img/map-marker.png',
            iconSize: [64, 64],
            iconAnchor: [32, 64],
            popupAnchor: [-3, -64]
        });
        L.marker([19.19, -100.13], {icon: myIcon}).addTo(map).bindPopup('FlyValle');
    </script>

    <script src="assets/js/vendors.js"></script>

    <!-- Syntaxhighlighter -->
    <script src="assets/js/syntaxhighlighter/shCore.js"></script>
    <script src="assets/js/syntaxhighlighter/shBrushXml.js"></script>
    <script src="assets/js/syntaxhighlighter/shBrushJScript.js"></script>

    <script src="assets/js/DropdownHover.js"></script>
    <script src="assets/js/app.js"></script>
    <script src="assets/js/holder.js"></script>
    <script src="assets/js/home_info.js"></script>
    <script src="assets/js/flyvalle.js"></script>
    <script src="assets/js/registration.js"></script>
    <script src="assets/js/login.js"></script>

</body>

</html>
