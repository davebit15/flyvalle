<!-- build:include layout/header.html --><!-- /build -->

<header class="main-header">
    <div class="container">
        <h1 class="page-title">Contact Us</h1>

        <ol class="breadcrumb pull-right">
            <li><a href="contact.cfm">Contact</a></li>
            <li class="active">Email Us</li>
        </ol>
    </div>
</header>

<div class="container">
    <div class="row">
        <div class="col-md-12">
            <h2 class="section-title no-margin-top">Send Message</h2>
        </div>
        <div class="col-md-8">
            <section>
                <p>Please send us a message using the form, or using your email software to <cfoutput><a href="mailto:#Application.contactEmail#"><strong>#Application.contactEmail#</strong></a></cfoutput>. We will get in touch as soon as possible.</p>

                <form role="form">
                    <div class="form-group">
                        <label for="InputName">Name</label>
                        <input type="email" class="form-control" id="InputName">
                    </div>
                    <div class="form-group">
                        <label for="InputEmail1">Email address</label>
                        <input type="email" class="form-control" id="InputEmail1">
                    </div>
                    <div class="form-group">
                        <label for="InputMessage">Mesagge</label>
                        <textarea class="form-control" id="InputMessage" rows="6"></textarea>
                    </div>
                    <button type="submit" class="btn btn-ar btn-primary">Submit</button>
                    <div class="clearfix"></div>
                </form>
            </section>
        </div>

        <div class="col-md-4">
            <section>
                <div class="panel panel-primary">
                    <div class="panel-heading"><i class="fa fa-envelope-o"></i> Additional Information</div>
                    <div class="panel-body">
                        <h4 class="section-title no-margin-top">Postal Address</h4>
                        <address>
                            <strong>FlyValle, Inc.</strong><br>
                            5 de Mayo 206<br>
                            Santa Mar&iacute;a Ahuacatl&aacute;n<br>
                            <abbr title="Phone">P:</abbr> (123) 456-7890 <br>
                            <cfoutput>Mail: <a href="mailto:#Application.contactEmail#">#Application.contactEmail#</a></cfoutput>
                        </address>

                        <!-- Business Hours -->
                        <h4 class="section-title no-margin-top">Business Hours</h4>
                        <ul class="list-unstyled">
                            <li><strong>Monday-Friday:</strong> 8am to 7pm</li>
                            <li><strong>Saturday:</strong> 8am to 3pm</li>
                            <li><strong>Sunday:</strong> 8am to 1pm</li>
                        </ul>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <hr class="dotted">
</div> <!-- container -->

<!-- build:include layout/footer.html --><!-- /build -->
