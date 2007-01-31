<cfsetting enablecfoutputonly="true">


	<!--- the apiKey should be set in _serverSpecificVars.cfm, the 'default' is really only here for Daemon testing --->
	<cfparam name="application.farcrylib.googlemaps.apiKey" default="ABQIAAAAhnUoATbGJlSL4ymKF9E5hRT-hFSaY96cab1rlRAA6pZ9tPpkQxTj4pGLjr4wwtp35u_5lW7_9e8MEA" type="string" />
	<cfparam name="key" default="#application.farcrylib.googlemaps.apiKey#" type="string" />
	<cfparam name="mapHeader" default="" type="string" />
	<cfparam name="bValidAddress" default="true" type="boolean" />
	<cfparam name="infoWindow" default="true" type="string" />
	<!--- the name of the div to display the map in, override if 'map' is already being used by your project --->
	<cfparam name="displayDivId" default="map" type="string" />
	<!--- param stObj keys --->
	<cfparam name="stObj.aLocations" default="#arrayNew(1)#" type="array" />
	<cfparam name="stObj.bMapTypeControl" default="false" type="boolean" />
	<cfparam name="stObj.bOverviewMapControl" default="false" type="boolean" />
	<cfparam name="stObj.OverviewWidth" default="150" type="numeric" />
	<cfparam name="stObj.OverviewHeight" default="150" type="numeric" />
	<cfparam name="stObj.height" default="" type="numeric" />
	<cfparam name="stObj.SizeMapControl" default="" type="string" />
	<cfparam name="stObj.width" default="" type="numeric" />
	<cfparam name="stObj.zoomLevel" default="13" type="numeric" />
	

	<!--- if a user hasn't set map dimensions in the webtop, default them --->
	<cfif NOT len(trim(stObj.height))>
		<cfset stObj.height = 500 />
	</cfif>	
	<cfif NOT len(trim(stObj.width))>
		<cfset stObj.width = 500 />
	</cfif>
	
	
	<!--- MAP OPTIONS --->
	<cfsavecontent variable="mapControls">
		<cfoutput>
			<cfif stObj.bMapTypeControl>
				map.addControl(new GMapTypeControl());	//load the map control (hybrid/satellite/map)
			</cfif>
	      	
	      	<cfswitch expression="#stObj.SizeMapControl#">
	      	
	      		<cfcase value="small">
	      			map.addControl(new GSmallMapControl());		//add a small map control to the map
	      		</cfcase>	 
	      		       		
	      		<cfcase value="large">
	      			map.addControl(new GLargeMapControl());		//add a large map control to the map
	      		</cfcase>	 
	      		
	      	</cfswitch>
		
			<cfif stObj.bOverviewMapControl>
				map.addControl(new GOverviewMapControl(new GSize(#stObj.OverviewWidth#,#stObj.OverviewHeight#)));	//add a small preview to the map
			</cfif>
		</cfoutput>
	</cfsavecontent>


	<!--- create the map location object --->
	<cfset oMapLocation = createObject("component", application.types["googleMapLocation"].packagepath) />

	
	<!--- generate the map javascript --->		
	<cfsavecontent variable="mapHeader">
	<cfoutput>
		
	<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=#key#" type="text/javascript"></script>
	<script type="text/javascript">
   	//<![CDATA[
		
		var address = "";	//blank for now
	    var zoomLevel = #stObj.zoomLevel#;
	    var map = null;
	    var geocoder = null;
	    var bValidAddress = 0;	//default for now
	    
	    function load() 
	    {
	    
			if (GBrowserIsCompatible()) 
	      	{
	      		
	      		// Creates a marker at the given point with the given number label
				function createMarker(point, html) {
				  var marker = new GMarker(point);
				  GEvent.addListener(marker, "click", function() {
				    marker.openInfoWindowHtml(html);
				  });
				  return marker;
				}
				
				var map = new GMap2(document.getElementById("#displayDivId#"));
				//map controls
				#mapControls#
	        
	        	if (bValidAddress)	//a valid address was found in the database, use geocoding to generate map
	        	{
	        	
		        	geocoder = new GClientGeocoder();
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
			    else	//a bad or invalid address, use long/lat to generate map...not as accurate as geocoding (for Australia anyway)
				{				
				
				<cfif len(stobj.centerLocationID)><!--- there is a center point to plot --->
					<cfset stMapLocation = oMapLocation.getData(objectid=stobj.centerLocationID) />
					map.setCenter(new GLatLng(#stMapLocation.longLat#), zoomLevel);
				<cfelseif arrayLen(stobj.aLocations)><!--- there are location(s) but no center to plot --->
					<cfset stMapLocation = oMapLocation.getData(objectid=stobj.aLocations[1]) />
					map.setCenter(new GLatLng(#stMapLocation.longLat#), zoomLevel);
				<cfelse><!--- hmm...problem, array of locations is empty --->
					map.setCenter(new GLatLng(0,0), zoomLevel);					
				</cfif>
	
				<cfset counter = 0 />
				<cfloop list="#arrayToList(stObj.aLocations)#" index="i">

					<cfset counter = counter + 1 />							
					<cfset stMapLocation = oMapLocation.getData(objectid=i) />
					<cfset sInfoWindow = oMapLocation.getView(objectid=i,template="displayInfoWindow") />
					
					var point = new GLatLng(#stMapLocation.longLat#);
					var marker = createMarker(point, "#JSStringFormat(sInfoWindow)#");
					map.addOverlay(marker);
					//map.addOverlay(createMarker(point, "#JSStringFormat(stMapLocation.Title)#"));
					
				</cfloop>						
		
				}
		      
	    	}

	    }
	    
	    window.onunload(GUnload());	//using onunload() to prevent memory leaks especially in IE

   	//]]>
   	</script>
	</cfoutput>
	</cfsavecontent>
	

	<!--- place the map javascript in the page header --->
	<cfhtmlhead text="#mapHeader#" />
	
	<cfoutput>
	
		<div id="#displayDivId#" style="width: #stObj.width#px; height: #stObj.height#px"></div><!--- html div to display the map --->
		
		<!--- load the google maps function --->
		<script type="text/javascript">
			window.load(load());
		</script>

	</cfoutput>


<cfsetting enablecfoutputonly="false">