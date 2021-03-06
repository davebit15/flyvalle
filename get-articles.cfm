<!-- build:include layout/header.html --><!-- /build -->

<cfscript>
    getArticlesData = CreateObject("component","cfc.articles");
    response = getArticlesData.getArticlesList();
</cfscript>

<header class="main-header">
    <div class="container">
        <h1 class="page-title">Articles</h1>

        <ol class="breadcrumb pull-right">
            <li><a href="resources.cfm">Resources</a></li>
            <li class="active">Articles</li>
        </ol>
    </div>
</header>

<div class="container">
    <div class="row">
        <div class="col-md-8 col-md-push-4">
            <cfif response.status EQ "success">
                <cfoutput query="response.articles">
                    <article class="post animated fadeInLeft animation-delay-8">
                        <div class="panel panel-default">
                            <div class="panel-body">
                                <h3 class="post-title"><a href="single.html" class="transicion">#title#</a></h3>
                                <div class="row">
                                    <div class="col-lg-6">
                                        <img src="assets/img/articles/#ID#.jpg" class="img-post img-responsive" alt="Image">
                                    </div>
                                    <div class="col-lg-6 post-content">
                                        #synopsis#
                                    </div>
                                </div>
                            </div>
                            <div class="panel-footer post-info-b">
                                <div class="row">
                                    <div class="col-lg-10 col-md-9 col-sm-8">
                                        <i class="fa fa-clock-o"></i> #DateFormat(creationDate, "medium")# <i class="fa fa-user"> </i <a href="##">#authorFName#</a> <i class="fa fa-folder-open"></i> <a href="##">Portfolio</a>, <a href="##">Design</a>.
                                    </div>
                                    <div class="col-lg-2 col-md-3 col-sm-4">
                                        <a href="##" class="pull-right">Read more &raquo;</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </article> <!-- post -->
                </cfoutput>

                <section>
                    <ul class="pagination">
                        <li class="disabled"><a href="#">&laquo;</a></li>
                        <li class="active"><a href="#">1 <span class="sr-only">(current)</span></a></li>
                        <li><a href="#">2</a></li>
                        <li><a href="#">3</a></li>
                        <li><a href="#">4</a></li>
                        <li><a href="#">5</a></li>
                        <li><a href="#">6</a></li>
                        <li><a href="#">7</a></li>
                        <li><a href="#">8</a></li>
                        <li><a href="#">9</a></li>
                        <li><a href="#">10</a></li>
                        <li><a href="#">&raquo;</a></li>
                    </ul>
                </section>
            <cfelse>
                <p>An error retrieving the articles has occurred. Please try refreshing the page.</p>
            </cfif>
        </div> <!-- col-md-8 -->
        <div class="col-md-4 col-md-pull-8">
            <aside class="sidebar">
                <div class="block animated fadeInDown animation-delay-12">
                    <div class="input-group">
                      <input type="text" placeholder="Search..." class="form-control">
                      <span class="input-group-btn">
                        <button class="btn btn-ar btn-primary" type="button"><i class="fa fa-search no-margin-right"></i></button>
                      </span>
                    </div><!-- /input-group -->
                </div>

                <div class="block animated fadeInDown animation-delay-10">
                    <ul class="nav nav-tabs nav-tabs-ar" id="myTab2">
                        <li class="active"><a href="#fav" data-toggle="tab"><i class="fa fa-star"></i></a></li>
                        <li><a href="#categories" data-toggle="tab"><i class="fa fa-folder-open"></i></a></li>
                        <li><a href="#archive" data-toggle="tab"><i class="fa fa-clock-o"></i></a></li>
                        <li><a href="#tags" data-toggle="tab"><i class="fa fa-tags"></i></a></li>
                    </ul>
                    <div class="tab-content">
                        <div class="tab-pane active" id="fav">
                            <h3 class="post-title no-margin-top">Favorite Post</h3>
                            <ul class="media-list">
                                <li class="media">
                                    <a class="pull-left" href="#"><img class="media-object" src="<%= assets %>img/demo/m2.jpg" width="80" height="80" alt="image"></a>
                                    <div class="media-body">
                                        <p class="media-heading"><a href="#">Lorem ipsum dolor sit amet aut consectetur adipisicing elitl libero</a></p>
                                        <small>Sep, 28 2013</small>
                                    </div>
                                </li>
                                <li class="media">
                                    <a class="pull-left" href="#"><img class="media-object" src="<%= assets %>img/demo/m9.jpg" width="80" height="80" alt="image"></a>
                                    <div class="media-body">
                                        <p class="media-heading"><a href="#">Lorem ipsum dolor sit amet in consectetur adipisicing</a></p>
                                        <small>Oct, 9 2013</small>
                                    </div>
                                </li>
                                <li class="media">
                                    <a class="pull-left" href="#"><img class="media-object" src="<%= assets %>img/demo/m12.jpg" width="80" height="80" alt="image"></a>
                                    <div class="media-body">
                                        <p class="media-heading"><a href="#">Sit amet consectetur adipisicing elit incidunt minus</a></p>
                                        <small>Dec, 30 2013</small>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="tab-pane" id="archive">
                             <h3 class="post-title no-margin-top">Archives</h3>
                            <ul class="simple">
                                <li><a href="#">December 2012</a></li>
                                <li><a href="#">January 2013</a></li>
                                <li><a href="#">February 2013</a></li>
                                <li><a href="#">March 2013</a></li>
                                <li><a href="#">April 2013</a></li>
                            </ul>
                        </div>
                        <div class="tab-pane" id="categories">
                             <h3 class="post-title no-margin-top">Categories</h3>
                            <ul class="simple">
                                <li><a href="#">Game Programming</a></li>
                                <li><a href="#">Artificial Intelligence</a>
                                    <ul>
                                        <li><a href="#">Artificial Life</a></li>
                                        <li><a href="#">Neural Networks</a></li>
                                    </ul>
                                </li>
                                <li><a href="#">Resources</a></li>
                                <li><a href="#">Web Developer</a></li>
                            </ul>
                        </div>

                        <div class="tab-pane" id="tags">
                             <h3 class="post-title">Tags</h3>
                            <div class="tags-cloud">
                                <a href="#" class="tag">Web</a>
                                <a href="#" class="tag">Artificial Intelligence</a>
                                <a href="#" class="tag">Programing</a>
                                <a href="#" class="tag">Design</a>
                                <a href="#" class="tag">3D</a>
                                <a href="#" class="tag">Games</a>
                                <a href="#" class="tag">Resources</a>
                                <a href="#" class="tag">2D</a>
                                <a href="#" class="tag">C++</a>
                                <a href="#" class="tag">Jquery</a>
                                <a href="#" class="tag">Javascript</a>
                                <a href="#" class="tag">Library</a>
                                <a href="#" class="tag">Windows</a>
                                <a href="#" class="tag">Linux</a>
                                <a href="#" class="tag">Cloud</a>
                                <a href="#" class="tag">Game developer</a>
                                <a href="#" class="tag">Server</a>
                                <a href="#" class="tag">Google</a>
                                <a href="#" class="tag">Bootstrap</a>
                                <a href="#" class="tag">Less</a>
                                <a href="#" class="tag">Sass</a>
                                <a href="#" class="tag">Engine</a>
                                <a href="#" class="tag">Node.js</a>
                            </div>
                        </div>
                    </div> <!-- tab-content -->
                </div>

                <div class="panel panel-primary animated fadeInDown animation-delay-8">
                    <div class="panel-heading"><i class="fa fa-play-circle"></i>Featured video</div>
                    <div class="video">
                        <iframe src="http://player.vimeo.com/video/21081887?title=0&amp;byline=0&amp;portrait=0"></iframe>

                    </div>
                </div>

                <div class="panel panel-primary animated fadeInDown animation-delay-6">
                    <div class="panel-heading"><i class="fa fa-comments"></i> Recent Comments</div>
                    <div class="panel-body">
                        <ul class="comments-sidebar">
                            <li>
                                <img src="<%= assets %>img/demo/client.jpg" class="img-responsive" alt="Image">
                                <h4><a href="#">Andrew</a> in <a href="#">Lorem ipsum Fugiat elit occaecat aute nisi</a></h4>
                                <p>Lorem ipsum Occaecat ut esse amet ut eiusmod laborum cillum voluptate do laboris dolor ut elit aliquip velit ut nulla anim ...</p>
                            </li>
                            <li>
                                <img src="<%= assets %>img/demo/client2.jpg" class="img-responsive" alt="Image">
                                <h4><a href="#">Andrew</a> in <a href="#">Lorem ipsum Fugiat elit occaecat aute nisi</a></h4>
                                <p>Lorem ipsum Occaecat ut esse amet ut eiusmod laborum cillum voluptate do laboris dolor ut elit aliquip velit ut nulla anim ...</p>
                            </li>
                            <li>
                                <img src="<%= assets %>img/demo/client6.jpg" class="img-responsive" alt="Image">
                                <h4><a href="#">Andrew</a> in <a href="#">Lorem ipsum Fugiat elit occaecat aute nisi</a></h4>
                                <p>Lorem ipsum Occaecat ut esse amet ut eiusmod laborum cillum voluptate do laboris dolor ut elit aliquip velit ut nulla anim ...</p>
                            </li>
                            <li>
                                <img src="<%= assets %>img/demo/client4.jpg" class="img-responsive" alt="Image">
                                <h4><a href="#">Andrew</a> in <a href="#">Lorem ipsum Fugiat elit occaecat aute nisi</a></h4>
                                <p>Lorem ipsum Occaecat ut esse amet ut eiusmod laborum cillum voluptate do laboris dolor ut elit aliquip velit ut nulla anim ...</p>
                            </li>
                            <li>
                                <img src="<%= assets %>img/demo/client5.jpg" class="img-responsive" alt="Image">
                                <h4><a href="#">Andrew</a> in <a href="#">Lorem ipsum Fugiat elit occaecat aute nisi</a></h4>
                                <p>Lorem ipsum Occaecat ut esse amet ut eiusmod laborum cillum voluptate do laboris dolor ut elit aliquip velit ut nulla anim ...</p>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="panel panel-primary animated fadeInDown animation-delay-4">
                    <div class="panel-heading"><i class="fa fa-align-left"></i> Widget Text</div>
                    <div class="panel-body">
                        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Atomus, appellat dedocendi omnes quoddam atomos. Vestra. Corrupti sensum multa dissentiet uberius displicet medeam, efficiatur quaeque saluto sollicitare arbitraretur conectitur chaere, deorum consiliisque arbitrer doctrina nasci. Odia malis, scipio, libido. Iudico graviter seditione hoc. Venustate.</p>
                    </div>
                </div>

            </aside> <!-- Sidebar -->
        </div>
    </div> <!-- row -->
</div> <!-- container  -->

<!-- build:include layout/footer.html --><!-- /build -->
