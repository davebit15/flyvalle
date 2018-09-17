<!DOCTYPE html>
<html lang="en">

<head>
    <cfquery name="getMeta" datasource="Application.metadata" dbtype="query">
        SELECT *
        FROM Application.metadata
        WHERE template = 'global'  OR template = 'login'
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

            <cfswitch expression="#SESSION.loginData.logged#">
                <cfcase value="0">
                    <!-- LOGIN FORM |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
                    <div class="row">
                        <div class="container mt-1">
                            <div class="col-md-6 col-sm-offset-3">
                                <h2 class="section-title no-margin-top">Log In</h2>
                                <div class="panel panel-primary animated fadeInRight animation-delay-2">
                                    <div class="panel-heading">Login Form</div>
                                    <div class="panel-body">
                                        <form id="loginForm" role="form">
                                            <div class="form-group">
                                                <div class="input-group login-input">
                                                    <span class="input-group-addon"><i class="fa fa-user"></i></span>
                                                    <input id="loginUsername" name="loginUsername" type="text" class="form-control" placeholder="Username or Email">
                                                </div>
                                                <br>
                                                <div class="input-group login-input">
                                                    <span class="input-group-addon"><i class="fa fa-lock"></i></span>
                                                    <input id="loginPassword" name="loginPassword" type="password" class="form-control" placeholder="Password">
                                                </div>
                                                <div class="checkbox">
                                                    <input type="checkbox" id="rememberMe" name="rememberMe" value="1">
                                                    <label for="rememberMe">Remember me</label>
                                                </div>
                                                <button type="submit" class="btn btn-ar btn-primary pull-right">Login</button>
                                                <a href="#" class="social-icon-ar sm twitter animated fadeInDown animation-delay-3"><i class="fa fa-twitter"></i></a>
                                                <a href="#" class="social-icon-ar sm google-plus animated fadeInDown animation-delay-4"><i class="fa fa-google-plus"></i></a>
                                                <a href="#" class="social-icon-ar sm facebook animated fadeInDown animation-delay-5"><i class="fa fa-facebook"></i></a>
                                                <hr>
                                                <a href="registration.cfm" class="btn btn-ar btn-success pull-right"><i class="fa fa-pencil"></i> Register</a>
                                                <a href="#" class="btn btn-ar btn-warning">Recover Password</a>
                                                <div class="clearfix"></div>
                                                <div id="loginAlert"></div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- LOGIN FORM |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
                </cfcase>
                <cfdefaultcase>
                    <div class="row">
                        <div class="container mt-1">
                            <div class="col-md-6 col-sm-offset-3">
                                <h2 class="section-title no-margin-top">Log In</h2>
                                <div class="panel panel-primary animated fadeInRight animation-delay-2">
                                    <cfoutput>
                                    <div class="panel-heading">You are logged in as <strong>#SESSION.loginData.username#</strong></div>
                                    <div class="panel-body">
                                        <button class="btn btn-info col-xs-12" style="margin: 5px 0;"><i class="fa fa-bell"></i> Check my notifications</button>
                                        <button class="btn btn-warning col-xs-12" style="margin: 5px 0;"><i class="fa fa-envelope"></i> Check my messages</button>
                                        <button class="btn btn-primary col-xs-12" style="margin: 5px 0;"><i class="fa fa-cubes"></i> Open my wishlist</button>
                                        <button class="btn btn-success col-xs-12" style="margin: 5px 0;"><i class="fa fa-list"></i> Open my order history</button>
                                        <button class="btn btn-info col-xs-12" style="margin: 5px 0;"><i class="fa fa-cogs"></i> Open my account preferences</button>
                                        <button id="logoutBtn" class="btn btn-danger col-xs-12" style="margin: 5px 0;"><i class="fa fa-sign-out"></i> Log out</button>
                                    </div>
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                    </div>
                </cfdefaultcase>
            </cfswitch>

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
