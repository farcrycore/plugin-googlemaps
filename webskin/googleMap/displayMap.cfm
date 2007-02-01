<!--- 
    Name			: displayMap.cfm
    Author			: Michael Sharman, Matthew Bryant
    Created			: January 26, 2007
	Last Updated	: February 01, 2007
    History			: Initial release (mps 26/01/2007)
					: 31/01/2007 - removed dependance of JS functions from the <body> tag, added extra map properties
    Purpose			: This display handler is responsible for loading/displaying that actual google map. 
					: Should be called from within another webskin, default example is webskin/googleMap/displayPageStandard.cfm
 --->
<cfsetting enablecfoutputonly="true">


	<!--- the apiKey should be set in your project _serverSpecificVars.cfm --->
	<cfparam name="application.farcrylib.googlemaps.apiKey" default="" type="string" />
	<cfparam name="key" default="#application.farcrylib.googlemaps.apiKey#" type="string" />
	<cfparam name="mapControls" default="" type="string" />
	<cfparam name="mapHeader" default="" type="string" />
	<cfparam name="bValidAddress" default="true" type="boolean" /><!--- to be used when we have geocoding in place --->
	<cfparam name="sInfoWindow" default="true" type="string" />
	<cfparam name="displayDivId" default="map" type="string" /><!--- the name of the div to display the map in, override if 'map' is already being used by your project --->
	<cfparam name="oMapLocation" default="" />
	<!--- PARAM STOBJ KEYS --->
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
	
	
	<!--- create the map location object which will give us all plot points --->
	<cfset oMapLocation = createObject("component", application.types["googleMapLocation"].packagepath) />
	
	
	<!--- MAP OPTIONS: Generate the possible map options to be added to the Javascript --->
	<cfsavecontent variable="mapControls">
		<cfoutput>
			<cfif stObj.bMapTypeControl>
				map.addControl(new GMapTypeControl());		//load the map control (hybrid/satellite/map)
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
	    
	    function loadGoogleMap() 
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
					           	marker.openInfoWindowHtml("#JSStringFormat(sInfoWindow)#");
			         		}
			       		}
			       	);
			       	
	        	}
			    else	//a bad or invalid address, use long/lat to generate map...not as accurate as geocoding (for Australia anyway)
				{				
	
	
				// Creates a marker at the given point with the info window onclick
				function createMarker(point, sInfo) {
				  var marker = new GMarker(point);
				  GEvent.addListener(marker, "click", function() {
				    marker.openInfoWindowHtml(sInfo);
				  });
				  return marker;
				}
				
				<cfset counter = 0 />
				<cfloop list="#arrayToList(stObj.aLocations)#" index="i">

					<cfset counter = counter + 1 />							
					<cfset stMapLocation = oMapLocation.getData(objectid=i) />
					<cfset sInfoWindow = oMapLocation.getView(objectid=i,template="displayInfoWindow") />
					
					<cfif counter EQ 1>
						map.setCenter(new GLatLng(#stMapLocation.longLat#), zoomLevel);
					</cfif>
					
					var point = new GLatLng(#stMapLocation.longLat#);
					map.addOverlay(createMarker(point, "#JSStringFormat(sInfoWindow)#"));
										
				</cfloop>
		
				}
		      
	    	}

	    }
	    
	    //using onunload() to prevent memory leaks especially in IE
	    window.onunload = function(){
	    	GUnload();
	    }

   	//]]>
   	</script>
	</cfoutput>
	</cfsavecontent>
	

	<!--- place the map javascript in the page header --->
	<cfhtmlhead text="#mapHeader#" />
	
	
	<cfoutput>
	
		<div id="#displayDivId#" style="width: #stObj.width#px; height: #stObj.height#px"></div><!--- html div to display the map --->
		
		<script type="text/javascript"><!--- function to load google maps --->
			window.load(loadGoogleMap());
		</script>

	</cfoutput>


<cfsetting enablecfoutputonly="false">