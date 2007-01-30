<cfsetting enablecfoutputonly="true">

	<!--- the apiKey should be set in _serverSpecificVars.cfm --->
	<cfparam name="application.farcrylib.googlemaps.apiKey" default="" />
	<cfparam name="key" default="ABQIAAAAhnUoATbGJlSL4ymKF9E5hRT-hFSaY96cab1rlRAA6pZ9tPpkQxTj4pGLjr4wwtp35u_5lW7_9e8MEA" type="string" />
	<cfparam name="scaleControl" default="1" type="numeric" />	
	<cfparam name="typeControl" default="0" type="numeric" />	
	<cfparam name="zoomLevel" default="13" type="string" />	
	<cfparam name="lLongLat" default="" type="string" />	
	<cfparam name="mapHeader" default="" type="string" />
	<cfparam name="bValidAddress" default="true" type="boolean" />
	<cfparam name="infoWindow" default="true" type="string" />
	
	
	<cfif NOT len(stObj.height)>
		<cfset stObj.height = 500 />
	</cfif>	
	<cfif NOT len(stObj.width)>
		<cfset stObj.width = 500 />
	</cfif>

	<cfif Len(stObj.Zoom)>
		<cfset zoomLevel = stObj.Zoom>
	</cfif>

	<cfset oMapLocation = createObject("component", application.types["googleMapLocation"].packagepath) />

		
	<cfsavecontent variable="mapHeader">
	<cfoutput>
	<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=#key#" type="text/javascript"></script>
	<script type="text/javascript">
   	//<![CDATA[
		
		var address = "";	//blank for now
	    var zoomLevel = #zoomLevel#;
	    var map = null;
	    var geocoder = null;
	    var bValidAddress = 0;	//default for now
	    
	    function load() 
	    {
	    
			if (GBrowserIsCompatible()) 
	      	{
				map = new GMap2(document.getElementById("map"));
	        	geocoder = new GClientGeocoder();
	        
	        	map.addControl(new GLargeMapControl());        
	        
	        	if (bValidAddress)	//a valid address was found in the database, use geocoding to generate map
	        	{
	        	
		        	geocoder.getLatLng(address,
		       			function(point) 
		       			{
		       				if (!point) 
		    	   		   		alert(address + " not found");
		        	 		else 
		        	 		{
					           	map.setCenter(point, zoomLevel);
					           	var marker = new GMarker(point);
					           	map.addOverlay(marker);
					           	marker.openInfoWindowHtml("#JSStringFormat(infoWindow)#");
			         		}
			       		}
			       	);
			       	
	        	}
			    else	//a bad or invalid address, use long/lat to generate map
				{
						<cfif len(stobj.centerLocationID)>
							<cfset stMapLocation = oMapLocation.getData(objectid=stobj.centerLocationID) />
							map.setCenter(new GLatLng(#stMapLocation.longLat#), zoomLevel);
						<cfelseif arrayLen(stobj.aLocations)>
							<cfset stMapLocation = oMapLocation.getData(objectid=stobj.aLocations[1]) />
							map.setCenter(new GLatLng(#stMapLocation.longLat#), zoomLevel);
						<cfelse>
							map.setCenter(new GLatLng(0,0), zoomLevel);
						</cfif>
					<!--- window.setTimeout(function() {
								  map.panTo(new GLatLng(#iLong#, #iLat#));
								}, 1000); --->
								
							
						// Creates a marker at the given point with the given number label
						function createMarker(point, tab) {
						  var marker = new GMarker(point);
						  GEvent.addListener(marker, "click", function() {
						    marker.openInfoWindowHtml(tab);
						  });
						  return marker;
						}
						<cfset counter = 0 />
						<cfloop list="#arrayToList(stObj.aLocations)#" index="i">
							<cfset counter = counter + 1 />
							<cfset stMapLocation = oMapLocation.getData(objectid=i) />
							var point = new GLatLng(#stMapLocation.longLat#);
							 map.addOverlay(createMarker(point, "<b>#JSStringFormat(stMapLocation.title)#</b><br />#JSStringFormat(stMapLocation.teaser)#"));
						</cfloop>
				}
	    	}
	    }
   	//]]>
   	</script>
	</cfoutput>
	</cfsavecontent>

	<cfhtmlhead text="#mapHeader#" />
	<cfoutput><div id="map" style="width: #stObj.width#px; height: #stObj.height#px"></div>
	<script>
	window.onload = load(); // Add the load function to the window onload
	// TO DO: the onunload should be in here too, but for some reason at the minute it prevents the map images from being displayed.
//	window.onunload = GUnload(); // Add the Google maps unload function to the window onunload
	</script>
	</cfoutput>


<cfsetting enablecfoutputonly="false">