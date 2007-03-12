<!--- 
    Name			: displayMap.cfm
    Author			: Michael Sharman, Matthew Bryant
    Created			: January 26, 2007
	Last Updated	: February 01, 2007
    History			: Initial release (mps 26/01/2007)
					: 31/Jan/2007 - removed dependance of JS functions from the <body> tag, added extra map properties
					: 05/Feb/2007 - added numberFormat() to remove possible decimal places on numeric database types
    Purpose			: This display handler is responsible for loading/displaying that actual google map. 
					: Should be called from within another webskin, default example is webskin/googleMap/displayPageStandard.cfm
 --->
<cfsetting enablecfoutputonly="true">



<!--- Import tag libraries --->
<cfimport taglib="/farcry/core/tags/webskin/" prefix="skin" />



	<!--- the apiKey should be set in your project _serverSpecificRequestScope.cfm --->
	<cfparam name="application.stplugins.googlemaps.apiKey" default="" type="string" />
	<cfparam name="key" default="#application.stplugins.googlemaps.apiKey#" type="string" />
	<cfparam name="mapControls" default="" type="string" />
	<cfparam name="mapHeader" default="" type="string" />
	<cfparam name="bValidAddress" default="true" type="boolean" /><!--- to be used when we have geocoding in place --->
	<cfparam name="sInfoWindow" default="true" type="string" />
	<cfparam name="displayDivId" default="map" type="string" /><!--- the name of the div to display the map in, override if 'map' is already being used by your project --->
	<cfparam name="oMapLocation" default="" />
	
		
	<cfparam name="arguments.stparam" default="#structNew()#" />
	

	
	
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

	      		<cfdefaultcase></cfdefaultcase> 

	      	</cfswitch>

			<cfif isBoolean(stObj.bOverviewMapControl) AND stObj.bOverviewMapControl>
				<cfif stObj.OverviewWidth GT 0 AND stObj.OverviewHeight GT 0>
				map.addControl(new GOverviewMapControl(new GSize(#stObj.OverviewWidth#,#stObj.OverviewHeight#)));	//add a small preview to the map
				<cfelse>
				map.addControl(new GOverviewMapControl());	//add a small preview to the map
				</cfif>
			</cfif>
		</cfoutput>
	</cfsavecontent>


	<!--- We only want to place the google maps js file once in the header. This wll allow for 2 maps to be placed on the 1 page. --->
	<skin:htmlhead id="googleMapJS#key#">
		<cfoutput><script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=#key#" type="text/javascript"></script></cfoutput>
	</skin:htmlhead>
	
	<!--- generate the map javascript and place the map javascript in the page header ---> 
	
	<skin:htmlhead>
	<cfoutput>			
	<script type="text/javascript">
   	//<![CDATA[

		var address = null;	//to be used if we are geoCoding
		var zoomLevel = #stObj.zoomLevel#;
		var map = null;
		var geocoder = null;


		function loadGoogleMap()	//loads a google map
		{

			if (GBrowserIsCompatible())
			{

				// Creates a marker at the given point with the given info window onclick
				function createMarker(point, html,icon) {
					var marker = new GMarker(point,icon);
					GEvent.addListener(marker, "click", function() {
					marker.openInfoWindowHtml(html);
					});
					return marker;
				}

				// Creates an icon given the URL and height and width of the icon
				function createIcon(iconurl,iconheight,iconwidth) {
					var icon = new GIcon();
					icon.image = iconurl;
					icon.iconSize = new GSize(iconwidth, iconheight);
					// anchor the centre of the icon to the point
					icon.iconAnchor = new GPoint(iconwidth/2,iconheight/2);
					// anchor the info window to the centre and 1/5 of the way down the icon.
					icon.infoWindowAnchor = new GPoint(iconwidth/2,iconheight/5);
					return icon;
				}
				
				var map = new GMap2(document.getElementById("#displayDivId#"));
				//map controls as chosen in Farcry
				#mapControls#
	
				</cfoutput>
				
				
	
				<cfset counter = 0 /><!--- used to determine if it is the first location to plot. The first location will be set to the center point of the map --->
				<cfset sCenter = "" /><!--- This variable will hold the javascript code to plot the centre point --->			
				
				
				<cfif structKeyExists(arguments.stParam, "aLocations") >
					
					<cfloop from="1" to="#arrayLen(arguments.stParam.aLocations)#" index="i">
						
						
						<cfset counter = counter + 1 />	
						
						<cfif not isStruct(arguments.stParam.aLocations[i])>
							<cfset stMapLocation = structNew() />
							<cfset stMapLocation.title = arguments.stParam.aLocations[i] />
							<cfset stMapLocation.teaser = arguments.stParam.aLocations[i] />
							<cfset stMapLocation.geoCode = arguments.stParam.aLocations[i] />
							<cfset stMapLocation.latLong = "" />
							<cfset stMapLocation.icon = "" />
							<cfset stMapLocation.iconURL = "" />
						<cfelse>
							<cfset stMapLocation = arguments.stParam.aLocations[i] />
						</cfif>
						<cfif NOT structKeyExists(stMapLocation, "teaser") OR NOT len(stMapLocation.teaser)>
							<cfset stMapLocation.teaser = stMapLocation.geoCode />
						</cfif>
						
						<cfif isDefined("stMapLocation.iconURL") and len(stMaplocation.iconURL)>
							<cfoutput>var thisIcon = '#stMapLocation.iconURL#';</cfoutput>
						<cfelseif isDefined("stMapLocation.icon") and Len(stMapLocation.Icon)>  // create an icon object for this location.
							<cfset stIconDetail = StructNew()>
							<cfset stIconDetail = oMapLocation.getIconDetail(objectID=i)>
							<cfoutput>var thisIcon = createIcon('#stIconDetail.IconURL#',#stIconDetail.height#,#stIconDetail.width#);</cfoutput>
						<cfelse> // or set it to nothing so we use the default icon.
							<cfoutput>var thisIcon = '';</cfoutput>
						</cfif>
						
						<cfif isDefined("stMapLocation.GeoCode") and len(trim(stMapLocation.GeoCode))><!--- there is a physical address...try geocoding to generate the map --->
							
							<cfoutput>
							address = '#JSStringFormat(trim(stMapLocation.GeoCode))#';	//the address to plot
	
							var geocoder = new GClientGeocoder();
							geocoder.getLatLng(address,
				       			function(point) 
				       			{
				       				if (!point) 
				    	   		   		alert(address + " not found");
				        	 		else 
				        	 		{
										<cfif counter EQ 1>
											<cfset sCenter = "map.setCenter(point, zoomLevel);" />
								       	</cfif>
								       	map.setCenter(point, zoomLevel);
								       	
										map.addOverlay(createMarker(point, "#JSStringFormat(trim(stMapLocation.teaser))#",thisIcon));
										//map.addOverlay(new GMarker(point));
					         		}
					       		}
					       	);		
							</cfoutput>
							
						<cfelseif len(trim(stMapLocation.latLong))><!--- no GeoCode, but there is a long/lat --->
							
							<cfif counter EQ 1>
								<cfset sCenter = "map.setCenter(new GLatLng(#stMapLocation.latLong#), zoomLevel);" />
							</cfif>
							<cfoutput>
							map.setCenter(new GLatLng(#stMapLocation.latLong#), zoomLevel);
							
							var point = new GLatLng(#stMapLocation.latLong#);
							map.addOverlay(createMarker(point, "#JSStringFormat(trim(sInfoWindow))#",thisIcon));
							//map.addOverlay(new GMarker(point));
							</cfoutput>
							
						</cfif>
						

					</cfloop>
					
				</cfif>
	
				<cfif arrayLen(stobj.aLocations)>
					
					
				
					<cfloop list="#arrayToList(stObj.aLocations)#" index="i">
	
						<cfset counter = counter + 1 />							
						<cfset stMapLocation = oMapLocation.getData(objectid=i) />
						
						
						<!--- If the webskin for the infoWindow does not exist, then we use the teaser --->
						<cfset sInfoWindow = oMapLocation.getView(objectid=i,template="displayInfoWindow", alternateHTML="#stMapLocation.teaser#") />
						<cfif Len(stMapLocation.Icon)>  // create an icon object for this location.
							<cfset stIconDetail = StructNew()>
							<cfset stIconDetail = oMapLocation.getIconDetail(objectID=i)>
							<cfoutput>var thisIcon = createIcon('#stIconDetail.IconURL#',#stIconDetail.height#,#stIconDetail.width#);</cfoutput>
						<cfelse> // or set it to nothing so we use the default icon.
							<cfoutput>var thisIcon = '';</cfoutput>
						</cfif>
						
						<cfif len(trim(stMapLocation.GeoCode))><!--- there is a physical address...try geocoding to generate the map --->
							
							<cfoutput>
							address = '#JSStringFormat(trim(stMapLocation.GeoCode))#';	//the address to plot
	
							var geocoder = new GClientGeocoder();
							geocoder.getLatLng(address,
				       			function(point) 
				       			{
				       				if (!point) 
				    	   		   		alert(address + " not found");
				        	 		else 
				        	 		{
										<cfif counter EQ 1>
											<cfset sCenter = "map.setCenter(point, zoomLevel);" />
								       	</cfif>
								       	map.setCenter(point, zoomLevel);
								       	
								       	<cfif len(sInfoWindow)>
								       		map.addOverlay(createMarker(point, "#JSStringFormat(trim(sInfoWindow))#",thisIcon));
								       	<cfelse>
								       		map.addOverlay(createMarker(point, "",thisIcon));
								       	</cfif>
										
										//map.addOverlay(new GMarker(point));
					         		}
					       		}
					       	);		
							</cfoutput>
							
						<cfelseif len(trim(stMapLocation.latLong))><!--- no GeoCode, but there is a long/lat --->
							
							<cfif counter EQ 1>
								<cfset sCenter = "map.setCenter(new GLatLng(#stMapLocation.latLong#), zoomLevel);" />
							</cfif>
							<cfoutput>
							map.setCenter(new GLatLng(#stMapLocation.latLong#), zoomLevel);
							
							var point = new GLatLng(#stMapLocation.latLong#);
							
					       	<cfif len(sInfoWindow)>
					       		map.addOverlay(createMarker(point, "#JSStringFormat(trim(sInfoWindow))#",thisIcon));
					       	<cfelse>
					       		map.addOverlay(createMarker(point, "",thisIcon));
					       	</cfif>
							
							//map.addOverlay(new GMarker(point));
							</cfoutput>
							
						</cfif>
	
					</cfloop>
					
					
					
				</cfif>
				
				
		<cfoutput>
		
				#sCenter#

			}
	    }


	    //using onunload() to prevent memory leaks especially in IE
	    window.onunload = function(){
	    	GUnload();
	    }
	    
	    //function to load google maps
	    window.onload = function(){	
		    loadGoogleMap();	
	    }

   	//]]>
   	</script>
	
	</cfoutput>
	</skin:htmlhead>
	
		
	
	
	
	
	<!--- html div to display the map --->
	<cfoutput>
		<div id="#displayDivId#" style="width: #stObj.width#px; height: #stObj.height#px"></div>
	</cfoutput>


<cfsetting enablecfoutputonly="false">