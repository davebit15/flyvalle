<cfscript>
  // Get visitor statistics
  getStats = createObject("component", "cfc.stats");
  statsData = getStats.getVisitorsData("month").data;

  totalVisitors = arraySum(statsData["visitors"]);
  visitorsList = valueList(statsData.visitors);
  datesList = "";

  for (i = 1; i <= statsData.recordCount; i++) {
    if (datesList EQ "") {
      datesList = "'" & statsData.visitDay[i] & "'";
    }
    else {
      datesList = datesList & ",'" & statsData.visitDay[i] & "'";
    }
  }

  // Get registration statistics
  regData = getStats.getNewRegistrations("month").data;

  totalRegistrations = arraySum(regData["regUsers"]);
  registrationsList = valueList(regData.regUsers);
  regDatesList = "";

  for (i = 1; i <= regData.recordCount; i++) {
    if (regDatesList EQ "") {
      regDatesList = "'" & regData.regDay[i] & "'";
    }
    else {
      regDatesList = regDatesList & ",'" & regData.regDay[i] & "'";
    }
  }

  // Get visits per country
  countryData = getStats.getVisitorCountries("month").data;

  countryDataList = "";

  for (i = 1; i <= countryData.recordCount; i++) {
    if (countryDataList EQ "") {
      countryDataList = '"' & countryData.countryISO[i] & '": ' & countryData.visitors[i];
    }
    else {
      countryDataList = countryDataList & ', "' & countryData.countryISO[i] & '": ' & countryData.visitors[i];
    }
  }

</cfscript>

<div class="container">
  <!-- Content Header (Page header) -->
  <section class="content-header">
    <h1>
      Dashboard
      <small>Monthly numbers</small>
    </h1>
    <ol class="breadcrumb">
      <li><a href="../index.cfm"><i class="fa fa-home"></i> Home</a></li>
      <li><a href="#"><i class="fa fa-dashboard"></i> Admin</a></li>
      <li class="active">Dashboard</li>
    </ol>
  </section>

  <section id="statsWidgets" class="content">
    <!-- Small boxes (Stat box) -->
    <div class="row">
      <div class="col-lg-3 col-xs-6">
        <!-- small box -->
        <div class="small-box bg-aqua">
          <div class="inner">
            <h3><cfoutput>#totalVisitors#</cfoutput></h3>
            <p>Visitors</p>
          </div>
          <div class="icon">
            <i class="fa fa-user"></i>
          </div>
          <a href="#" class="small-box-footer" data-toggle="modal" data-target="#modal-info">More info <i class="fa fa-arrow-circle-right"></i></a>
        </div>
      </div>
      <!-- ./col -->
      <div class="col-lg-3 col-xs-6">
        <!-- small box -->
        <div class="small-box bg-green">
          <div class="inner">
            <h3><cfoutput>#totalRegistrations#</cfoutput></h3>
            <p>New Registrations</p>
          </div>
          <div class="icon">
            <i class="fa fa-bar-chart"></i>
          </div>
          <a href="#" class="small-box-footer" data-toggle="modal" data-target="#modal-success">More info <i class="fa fa-arrow-circle-right"></i></a>
        </div>
      </div>
      <!-- ./col -->
      <div class="col-lg-3 col-xs-6">
        <!-- small box -->
        <div class="small-box bg-yellow">
          <div class="inner">
            <h3>44</h3>
            <p>User Registrations</p>
          </div>
          <div class="icon">
            <i class="ion ion-person-add"></i>
          </div>
          <a href="#" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
        </div>
      </div>
      <!-- ./col -->
      <div class="col-lg-3 col-xs-6">
        <!-- small box -->
        <div class="small-box bg-red">
          <div class="inner">
            <h3>65<sup style="font-size: 20px">%</sup></h3>
            <p>Unique Visitors</p>
          </div>
          <div class="icon">
            <i class="ion ion-pie-graph"></i>
          </div>
          <a href="#" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
        </div>
      </div>
      <!-- ./col -->
    </div>
    <!-- /.row -->
  </section>

  <!-- Content Header (Page header) -->
  <section class="content-header">
    <h1>
      Traffic
      <small>Visits by country</small>
    </h1>
  </section>
  <section id="visitorsMap" class="content">
    <!-- Map box -->
    <div class="box box-solid bg-light-blue-gradient">
      <div class="box-body">
        <div id="world-map" style="height: 300px; width: 100%;"></div>
      </div>
      <!-- /.box-body-->
    </div>
    <!-- /.box -->
  </section>
</div>
<!-- container -->

<div class="modal modal-info fade" id="modal-info">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title">Visitors</h4>
      </div>
      <div class="modal-body">

        <canvas id="visitorsChart" width="400" height="200"></canvas>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline" data-dismiss="modal">Close</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<!-- /.modal -->

<div class="modal modal-success fade" id="modal-success">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title">Registrations</h4>
      </div>
      <div class="modal-body">

        <canvas id="registrationsChart" width="400" height="200"></canvas>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline" data-dismiss="modal">Close</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<!-- /.modal -->