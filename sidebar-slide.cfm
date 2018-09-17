<div class="sb-slidebar sb-right sb-style-overlay">
    <div class="input-group">
        <input type="text" class="form-control" placeholder="Search the store...">
        <span class="input-group-btn">
            <button class="btn btn-default" type="button"><i class="fa fa-search"></i></button>
        </span>
    </div><!-- /input-group -->

    <h2 class="slidebar-header no-margin-bottom"><i class="fa fa-shopping-cart"> </i> Store </h2>
    <ul class="slidebar-menu">
        <li><a href="page_about3.html">Gliders<span class="label label-success pull-right">New</span></a></li>
        <li><a href="portfolio_topbar.html">Harnesses</a></li>
        <li><a href="page_contact.html">Reserves</a></li>
        <li><a href="blog.html">Electronics<span class="label label-success pull-right">New</span></a></li>
        <li><a href="page_contact.html">Accessories</a></li>
    </ul>

    <h2 class="slidebar-header">Real-time weather</h2>
    <cfoutput>
        <div class="slidebar-social-icons">
            <cfloop index="i" from="1" to="#arrayLen(SESSION.openWeather.response.data.weather)#">
                <a href="##" class="social-icon-ar" rel="tooltip" data-toggle="tooltip" data-placement="auto" data-original-title="#SESSION.openWeather.response.data.weather[i].description#" style="background-color: ###SESSION.openWeather.response.data.weather[i].icon_wi_bgcolor#">
                    <i class="wi #SESSION.openWeather.response.data.weather[i].icon_wi#"></i>
                </a>
            </cfloop>
            <a href="##" class="social-icon-ar" rel="tooltip" data-toggle="tooltip" data-placement="auto" data-original-title="temperature: #SESSION.openWeather.response.data.main.temp##SESSION.openWeather.response.data.main.temp_unit#" style="background-color: ##e20808">
                <i class="wi #SESSION.openWeather.response.data.main.temp_icon#"></i>
            </a>
            <a href="##" class="social-icon-ar" rel="tooltip" data-toggle="tooltip" data-placement="auto" data-original-title="pressure: #SESSION.openWeather.response.data.main.pressure#HPa" style="background-color: ##9e15cd">
                <i class="wi #SESSION.openWeather.response.data.main.pressure_icon#"></i>
            </a>
            <a href="##" class="social-icon-ar" rel="tooltip" data-toggle="tooltip" data-placement="auto" data-original-title="humidity: #SESSION.openWeather.response.data.main.humidity#%" style="background-color: ##198397">
                <i class="wi #SESSION.openWeather.response.data.main.humidity_icon#"></i>
            </a>
            <a href="##" class="social-icon-ar" rel="tooltip" data-toggle="tooltip" data-placement="auto" data-original-title="wind: #SESSION.openWeather.response.data.wind.wind_message#" style="background-color: ##4b9719">
                <i class="wi #SESSION.openWeather.response.data.wind.wind_icon#"></i>
            </a>
            <a href="##" class="social-icon-ar" rel="tooltip" data-toggle="tooltip" data-placement="auto" data-original-title="cloud Cover: #SESSION.openWeather.response.data.clouds.all#%" style="background-color: ##564bdf">
                <i class="wi #SESSION.openWeather.response.data.clouds.clouds_icon#"></i>
            </a>
            <a href="##" class="social-icon-ar" rel="tooltip" data-toggle="tooltip" data-placement="auto" data-original-title="sunrise: #TimeFormat(SESSION.openWeather.response.data.sys.sunrise_lt,"medium")#" style="background-color: ##fa7bd2">
                <i class="wi #SESSION.openWeather.response.data.sys.sunrise_icon#"></i>
            </a>
            <a href="##" class="social-icon-ar" rel="tooltip" data-toggle="tooltip" data-placement="auto" data-original-title="sunset: #TimeFormat(SESSION.openWeather.response.data.sys.sunset_lt,"medium")#" style="background-color: ##cd6015">
                <i class="wi #SESSION.openWeather.response.data.sys.sunset_icon#"></i>
            </a>
        </div>
        <iframe width="100%" height="240" src="https://embed.windy.com/embed2.html?lat=19.194&lon=-100.134&zoom=11&level=surface&overlay=wind&menu=&message=&marker=&calendar=&pressure=&type=map&location=coordinates&detail=&detailLat=25.709&detailLon=-80.406&metricWind=mph&metricTemp=default" frameborder="0"></iframe>
    </cfoutput>
    
    <div></div>

    <div class="visible-xs-block">
        <h2 class="slidebar-header">Social Media</h2>
        <div class="slidebar-social-icons">
            <a href="#" class="social-icon-ar facebook"><i class="fa fa-facebook"></i></a>
            <a href="#" class="social-icon-ar twitter"><i class="fa fa-twitter"></i></a>
            <a href="#" class="social-icon-ar google-plus"><i class="fa fa-google-plus"></i></a>
            <a href="#" class="social-icon-ar instagram"><i class="fa fa-instagram"></i></a>
            <a href="#" class="social-icon-ar flickr"><i class="fa fa-flickr"></i></a>
        </div>        
    </div>

</div> <!-- sb-slidebar sb-right -->