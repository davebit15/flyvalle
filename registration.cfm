<cfscript>
if (SESSION.loginData.logged NEQ 0) {
    location("login.cfm", "false");
}
</cfscript>

<!DOCTYPE html>
<html lang="en">

<head>
    <cfquery name="getMeta" datasource="Application.metadata" dbtype="query">
        SELECT *
        FROM Application.metadata
        WHERE template = 'global' OR template = 'registration'
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

    <title>flyvalle: Registration</title>

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

            </cfscript>

            <!-- REGISTRATION FORM |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
            <div class="row">
                <div class="container mt-1">
                    <div class="col-md-6 col-sm-offset-3">
                        <h2 class="section-title no-margin-top">Create Account</h2>
                        <div class="panel panel-primary animated fadeInRight animation-delay-2">
                            <div class="panel-heading">Registration Form</div>
                            <div class="panel-body">
                                <form id="subscriptionForm" role="form" name="subscriptionForm">
                                    <div class="form-group">
                                        <label for="registrationUserName">User Name<sup>*</sup></label>
                                        <input type="text" class="form-control" id="registrationUserName" name="username" data-path="./">
                                    </div>
                                    <div id="username-alert" class="alert alert-warning">
                                        <span></span>
                                    </div>
                                    <div class="form-group">
                                        <label for="registrationFirstName">First Name</label>
                                        <input type="text" class="form-control" id="registrationFirstName" name="firstName" data-path="./">
                                    </div>
                                    <div class="form-group">
                                        <label for="registrationLastName">Last Name</label>
                                        <input type="text" class="form-control" id="registrationLastName" name="lastName">
                                    </div>
                                    <div class="form-group">
                                        <label for="registrationEmail">Email<sup>*</sup></label>
                                        <input type="email" class="form-control" id="registrationEmail" name="email" data-path="./">
                                    </div>
                                    <div id="email-alert" class="alert alert-warning">
                                        <span></span>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="registrationPassword">Password<sup>*</sup></label>
                                                <input type="password" class="form-control" id="registrationPassword" name="password" data-path="./">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="registrationConfirmPassword">Confirm Password<sup>*</sup></label>
                                                <input type="password" class="form-control" id="registrationConfirmPassword" name="confpassword" data-path="./">
                                            </div>
                                        </div>
                                    </div>
                                    <div id="password-alert" class="alert alert-warning">
                                        <span></span>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="checkbox checkbox-inline">
                                                <input type="checkbox" id="termsAgreement" name="terms" value="1">
                                                <label for="termsAgreement"><small>I agree with FlyValle's <a href="terms.cfm">Terms and Conditions</a></small></label>
                                            </div>
                                        </div>
                                        <input type="hidden" name="role" value="1">
                                        <div class="col-md-4">
                                            <button id="subscriptionBtn" type="submit" class="btn btn-ar btn-primary pull-right" data-path="./">Register</button>
                                        </div>
                                    </div>
                                    <div id="agreement-alert" class="alert alert-warning mt-1">
                                        <span></span>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            <!-- REGISTRATION FORM |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->

            <cfscript>

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

    <script src="assets/js/vendors.js"></script>

    <!--<script type="text/javascript" src="assets/js/jquery.themepunch.tools.min.js?rev=5.0"></script>
    <script type="text/javascript" src="assets/js/jquery.themepunch.revolution.min.js?rev=5.0"></script>-->


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
