<cfscript>
    getSMData = CreateObject("component","cfc.socialmedia");
    socialMedia = getSMData.getSocialMediaData().data;
</cfscript>
<cfoutput>
<header id="header-full-top" class="hidden-xs header-full">
    <div class="container">
        <div class="header-full-title">
            <cfoutput>
                <h1 class="animated fadeInRight"><a href="#request.webRoot#index.cfm"><span>fly</span> valle!</a></h1>
            </cfoutput>
            
            <p class="animated fadeInRight">the winter soaring site</p>
        </div>
        <nav class="top-nav">
            <ul class="top-nav-social hidden-sm">
                <cfloop query="#socialMedia#">
                    <li><a href="#url#" class="animated fadeIn animation-delay-7 #symbolname#"><i class="fa #fontawesome#"></i></a></li>
                </cfloop>
            </ul>
            <cfif SESSION.loginData.logged EQ 0>
                <cfif SESSION.actualPage NEQ "login.cfm">
                    <div class="dropdown animated fadeInDown animation-delay-11">
                        <a href="##" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-user"></i> Login</a>
                        <div class="dropdown-menu dropdown-menu-right dropdown-login-box animated fadeInRight">
                            <form id="loginForm" role="form">
                                <h4>Login Form</h4>
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
                                    <div class="checkbox pull-left">
                                        <input type="checkbox" id="rememberMe" name="rememberMe" value="1" />
                                        <label for="rememberMe">
                                            Remember me
                                        </label>
                                    </div>
                                    <button type="submit" class="btn btn-ar btn-primary pull-right">Login</button>
                                    <div class="clearfix"></div>
                                    <div id="loginAlert"></div>
                                </div>
                            </form>
                            <hr>
                            <a href="registration.cfm" id="registration-btn" class="btn btn-ar btn-success pull-right"><i class="fa fa-pencil"></i> Register</a>
                            <a href="password-recovery.cfm" class="btn btn-ar btn-warning">Recover Password</a>
                        </div>
                    </div>
                </cfif>
                <cfif SESSION.actualPage NEQ "registration.cfm">
                    <div class="dropdown animated fadeInDown animation-delay-11">
                        <a id="registration-box" href="##" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-pencil"></i> Register</a>
                        <div class="dropdown-menu dropdown-menu-right dropdown-registration-box animated fadeInRight">
                            <div class="panel-body">
                                <form id="subscriptionForm" role="form" name="subscriptionForm">
                                    <h4>Registration Form</h4>
                                    <div class="form-group">
                                        <label for="registrationUserName">User Name<sup>*</sup></label>
                                        <input type="text" class="form-control" id="registrationUserName" name="username" data-path="./">
                                    </div>
                                    <div id="username-alert" class="alert alert-warning">
                                        <span></span>
                                    </div>
                                    <div class="form-group">
                                        <label for="registrationFirstName">First Name</label>
                                        <input type="text" class="form-control" id="registrationFirstName" name="firstName">
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
                                                <input type="checkbox" id="termsAgreement" value="1">
                                                <label for="termsAgreement"><small>I agree with FlyValle's <a  style="background-color: transparent; border: none; padding: 0;" href="terms.cfm">Terms and Conditions</a></small></label>
                                            </div>
                                        </div>
                                        <input type="hidden" name="role" value="1">
                                        <div class="col-md-4">
                                            <button id="subscriptionBtn" type="submit" class="btn btn-ar btn-primary pull-right" data-path="./">Register</button>
                                        </div>
                                    </div>
                                    <div id="agreement-alert" class="alert alert-warning">
                                        <span></span> 
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div> <!-- dropdown -->
                </cfif>
            <cfelse>
                <cfif structKeyExists(SESSION.loginData, "accessLevel") AND SESSION.loginData.accessLevel GT 0>                    
                    <div class="dropdown animated fadeInDown animation-delay-11">
                        <cfoutput>
                            <cfif SESSION.loginData.firstName NEQ "" AND SESSION.loginData.lastName NEQ "">
                                <cfset loginName = SESSION.loginData.firstName & " " & SESSION.loginData.lastName />
                            <cfelse>
                                <cfset loginName = SESSION.loginData.username />
                            </cfif>
                            <a href="##" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-user"></i> #loginName#</a>
                            <div class="dropdown-menu dropdown-menu-right animated fadeInRight">
                                <ul class="dropdown-menu-user">
                                    <li><a href="##"><i class="fa fa-bell user-menu-icon"></i> Notifications</a></li>
                                    <li><a href="##"><i class="fa fa-envelope user-menu-icon"></i> Messages</a></li>
                                    <li><a href="##"><i class="fa fa-cubes user-menu-icon"></i> Wish list</a></li>
                                    <li><a href="##"><i class="fa fa-list user-menu-icon"></i> Order history</a></li>
                                    <li><a href="##"><i class="fa fa-cogs user-menu-icon"></i> Account</a></li>
                                    <cfif SESSION.loginData.accessLevel GT 1>
                                        <li role="presentation" class="dropdown-header"> Website Administration</li>
                                        <li><a href="#request.webRoot#admin/dashboard.cfm"><i class="fa fa-dashboard user-menu-icon"></i> Dashboard</a></li>
                                        <li><a href="#request.webRoot#admin/users.cfm"><i class="fa fa-users user-menu-icon"></i> Manage Users</a></li>
                                        <li><a href="#request.webRoot#admin/articles.cfm"><i class="fa fa-file-text-o user-menu-icon"></i> Articles</a></li>                                   
                                    </cfif>
                                    <li class="divider"></li>
                                    <li><a href="javascript:void(0);" id="userLogout"><i class="fa fa-sign-out user-menu-icon"></i> Logout</a></li>
                                </ul>
                            </div>
                        </cfoutput>
                    </div>
                </cfif>
            </cfif>
            <div class="dropdown animated fadeInDown animation-delay-13">
                <a href="##" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-search"></i></a>
                <div class="dropdown-menu dropdown-menu-right dropdown-search-box animated fadeInRight">
                    <form role="form">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Search...">
                            <span class="input-group-btn">
                                <button class="btn btn-ar btn-primary" type="button">Go!</button>
                            </span>
                        </div><!-- /input-group -->
                    </form>
                </div>
            </div> <!-- dropdown -->
        </nav>
    </div> <!-- container -->
</header> <!-- header-full -->
</cfoutput>