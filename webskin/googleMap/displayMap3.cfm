<cfsetting enablecfoutputonly="true">
<!---
    Name			: displayMap3.cfm
    Author			: AJM
    Created			: November 13, 2018
	Last Updated	: 
    History			:
    Purpose			: This display handler is responsible for loading/displaying that actual google map V3.
 --->
<!--- @@displayname: Display Map v3 --->

<!--- Import tag libraries --->
<cfimport taglib="/farcry/core/tags/webskin/" prefix="skin" />

<cftry>
	<cfparam name="stObj.displayDivId" default="map" type="string" />
	
	<!--- create the map location object which will give us all plot points --->
	<cfset oMapLocation = createObject("component", application.types["googleMapLocation"].packagepath) />

	<cfset stMapLocation = oMapLocation.getData(objectid=stObj.aLocations[1]) /><!--- TODO: loop array --->
	<cfset lat = Trim(ListFirst(stMapLocation.LATLONG))>
	<cfset lng = Trim(ListLast(stMapLocation.LATLONG))>
	
<cfoutput>
	<div id="#stObj.displayDivId#" class="gm-map" style="width:#stObj.width#px;height:#stObj.height#px"></div>
</cfoutput>

	<skin:htmlhead>
	<cfoutput>
    <script>
      var map;
      function initMap() {
      	// The location of Marker
		var location1 = {lat: #lat#, lng: #lng#};

		map = new google.maps.Map(document.getElementById('#stObj.displayDivId#'), {
			center: location1,
	        zoom: #stObj.ZOOMLEVEL#,
          
	        zoomControl: true,
			mapTypeControl: true,
	  		scaleControl: true,
	  		streetViewControl: false,
	  		rotateControl: false,
	  		fullscreenControl: false
        });
        
		  var contentString = '<div id="content">'+
		      '<div id="siteNotice">'+
		      '</div>'+
		      '<h1 id="firstHeading" class="firstHeading">#stMapLocation.title#</h1>'+
		      '<div id="bodyContent">'+
		      '#stMapLocation.teaser#'+
		      '</div>'+
		      '</div>';
	
		  var infowindow = new google.maps.InfoWindow({
		    content: contentString
		  });
        
		var marker = new google.maps.Marker({position: location1, map: map, title: '#stMapLocation.title#'});
		
		marker.addListener('click', function() {
			infowindow.open(map, marker);
		});
	}
    </script>
	</cfoutput>
	</skin:htmlhead>
		
	<!--- We only want to place the google maps js file once in the header. This wll allow for 2 maps to be placed on the 1 page. --->
	<skin:htmlhead id="googleMapsAPI">
		<cfoutput><script src="//maps.googleapis.com/maps/api/js?key=#application.config.googleMaps.apiKey#&callback=initMap" async defer></script></cfoutput>
	</skin:htmlhead>	
<cfoutput>    
  	</body>
</cfoutput>


	<cfcatch>
		<cfdump var="#CFCATCH#" label="ERROR" abort="YES"  />
	</cfcatch>
</cftry>

<cfsetting enablecfoutputonly="false">