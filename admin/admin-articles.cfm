<cfscript>
    getArticlesData = CreateObject("component","cfc.articles");
    response = getArticlesData.getArticlesList();
</cfscript>

<div class="container">
	<!-- Content Header (Page header) -->
	<section class="content-header">
		<h1>
			Articles <small>Content editor</small>
		</h1>
		<ol class="breadcrumb">
			<li><a href="../index.cfm"><i class="fa fa-home"></i> Home</a></li>
			<li><a href="dashboard.cfm"><i class="fa fa-dashboard"></i> Admin</a></li>
			<li class="active">Articles</li>
		</ol>
	</section>
    <cfif response.status EQ "success">
	 	<section class="content">
			<div class="row">
				<div class="col-xs-12">
					<div class="box">
						<div class="box-header">
							<h3 class="box-title">Select an article to edit or create a new one</h3> <button class="btn btn-sm btn-primary" data-toggle="modal" data-target="#modal-article"><i class="fa fa-plus-circle"></i> New Article</button>
						</div>
						<hr/>
						<!-- /.box-header -->
						<div class="box-body">
							<table id="articles-table" class="table table-bordered table-striped">
								<thead>
									<tr>
										<th>Created on</th>
										<th>Modified on</th>
										<th>Title</th>
										<th>Author</th>
										<th></th>
									</tr>
								</thead>
								<tbody>
						        <cfoutput query="response.articles">
									<tr>
										<td>#DateFormat(creationDate,"YYYY-MM-DD")#</td>
										<td>#DateFormat(modificationDate,"YYYY-MM-DD")#</td>
										<td>#title#</td>
										<td>#authorFName# #authorLName#</td>
										<td class="text-right">
											<button class="btn btn-xs btn-success" data-toggle="modal" data-target="##modal-article"><i class="fa fa-edit"></i></button>
											<button href="" class="btn btn-xs btn-danger" data-toggle="modal" data-target="##modal-danger"><i class="fa fa-cut"></i></button>
										</td>
									</tr>
						        </cfoutput>
								</tbody>
								<tfoot>
									<tr>
										<th>Created on</th>
										<th>Modified on</th>
										<th>Title</th>
										<th>Author</th>
										<th></th>
									</tr>
								</tfoot>
							</table>
						</div>
						<!--- /.box-body --->
					</div>
					<!--- /.box --->
				</div>
				<!--- /.col-xs-12 --->
			</div>
			<!--- /.row --->
		</section>
		<!--- /.content --->
	<cfelse>
	 	<section class="content">
			<div class="row">
				<div class="col-xs-12">
					<div class="box">
						<div class="box-header">
							<cfoutput>
								<h3 class="box-title">An error occurred while trying to retrieve the data. The application returned the following message: #response.status#</h3>
							</cfoutput>
						</div>
					</div>
				</div>
			</div>
		</section>
    </cfif>
	<!--- Insert form modal --->
	<div class="modal fade" id="modal-article">
		<div class="modal-dialog modal-lg">
			<form>
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
						<h3 class="box-title">Article Editor <small>Enter the information for this article</small></h3>
					</div>
					<div class="modal-body">
						<!-- Date dd/mm/yyyy -->
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon" style="color: #999;">
									<i class="fa fa-calendar"></i>
								</div>
								<input type="text" class="form-control" placeholder="Article Creation Date (MM-DD-YYYY)" data-inputmask="'alias': 'Article creation date (MM-DD-YYYY)'" data-mask>
							</div>
						<!-- /.input group -->
						</div>
						<!-- /.form group -->
						<div class="form-group">
							<input type="text" class="form-control" id="article-title" placeholder="Title of the article (required)">
						</div>
						<!--- WYSIHTML5 text editor --->
						<textarea id="article-synopsis" class="textarea" placeholder="Synopsis of the article (optional)" style="width: 100%; height: 80px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;margin-bottom:10px;"></textarea>
						<textarea id="article-body" class="textarea" placeholder="Text of the article (required)" style="width: 100%; height: 300px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;"></textarea>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
						<button type="button" class="btn btn-primary">Save changes</button>
					</div>
				</div>
				<!-- /.modal-content -->
			</form>
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->

	<!--- Delete warning modal --->
	<div class="modal modal-danger fade" id="modal-danger">
		<div class="modal-dialog modal-sm">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span></button>
					<h4 class="modal-title">Are you sure you want to delete this article?</h4>
				</div>
				<div class="modal-body">
					<p>This operation can't be undone.</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-outline pull-left" data-dismiss="modal">Abort</button>
					<button type="button" class="btn btn-outline">Delete the bitch</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->

</div>
<!--- ./container --->