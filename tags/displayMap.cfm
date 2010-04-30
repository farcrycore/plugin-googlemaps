<cfsetting enablecfoutputonly="yes" />
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


<!--- TODO Investigate http://mapstraction.com/trac/wiki/MapstractionAPI as a common API for multiple map services --->

<!--- Import tag libraries --->
<cfimport taglib="/farcry/core/tags/webskin/" prefix="skin" />

<cfif thistag.executionMode eq "Start">

	<!--- the apiKey should be set in your project _serverSpecificRequestScope.cfm --->
	<cfparam name="application.stplugins.googleMaps.apiKey" default="" type="string" />
	<cfparam name="attributes.key" default="#application.stplugins.googleMaps.apiKey#" type="string" />
	<cfparam name="application.stplugins.googleMaps.stKeys" default="#structNew()#" type="struct" />
	<cfparam name="attributes.stParam.mapType" default="G_MAP_TYPE" type="string" />
	<cfparam name="attributes.stParam.bDisplayInfoWindow" default="true" type="boolean" />
	<cfparam name="attributes.stParam.displayDivId" default="map" type="string" /><!--- the name of the div to display the map in, override if 'map' is already being used by your project --->
	<cfparam name="attributes.stParam.sizeMapControl" default="large" />
	<cfparam name="attributes.stParam.mapTypeControlFormat" default="" />
	<cfparam name="attributes.stParam.bDisplayMapControl" default="true" />
	<cfparam name="attributes.stParam.bDisplayMarkerList" default="false" />
	<cfparam name="attributes.stParam.bDisplayScaleControl" default="false" />
	
	<!--- Miscellaneous Map Options --->
	<cfparam name="attributes.stParam.bEnableGoogleBar" default="false" />
	<cfparam name="attributes.stParam.bEnableScrollWheelZoom" default="false" />
	<cfparam name="attributes.stParam.bEnableContinuousZoom" default="false" />
	<cfparam name="attributes.stParam.bEnableDoubleClickZoom" default="false" />
	<cfparam name="attributes.stParam.bEnableGKeyboardHandler" default="false" />
	<cfparam name="attributes.stParam.bShowDirectionsLink" default="false" />
	<cfparam name="attributes.stParam.bShowGoogleEarthLink" default="false" />
	
	<cfparam name="attributes.stParam" default="#structNew()#" />
	
	<cfif not len(attributes.key)>
		<cfif structKeyExists(application.stplugins.googleMaps.stKeys, cgi.HTTP_HOST)>
			<cfset attributes.key = application.stplugins.googleMaps.stKeys[cgi.HTTP_HOST] />
		<cfelse>
			<cfset attributes.key = application.stplugins.googleMaps.apiKey />
		</cfif>
	</cfif>

	<!--- if a user hasn't set map dimensions in the webtop, default them --->
	<cfif NOT IsNumeric(attributes.stParam.height)>
		<cfset attributes.stParam.height = 500 />
	</cfif>
	<cfif NOT IsNumeric(attributes.stParam.width)>
		<cfset attributes.stParam.width = 500 />
	</cfif>

	<!--- create the map location object which will give us all plot points --->
	<cfset oMapLocation = createObject("component", application.types["googleMapLocation"].packagepath) />

	<!--- MAP OPTIONS: Generate the possible map options to be added to the Javascript --->
	<cfsavecontent variable="mapControls">
		<cfif isBoolean(attributes.stParam.bMapTypeControl) AND attributes.stParam.bMapTypeControl>
			
			<cfif attributes.stParam.SizeMapControl eq "small">
				<cfset sSizeMapControl = "true" /> <!--- small map controls --->
			<cfelse>
				<cfset sSizeMapControl = "" /> <!--- default (large) map controls --->
			</cfif>
			
			<cfswitch expression="#attributes.stParam.mapTypeControlFormat#">

	     		<cfcase value="menu">
					<!--- See http://econym.googlepages.com/reference.htm#GMenuMapTypeControl --->
					<cfoutput>map.addControl(new GMenuMapTypeControl(#sSizeMapControl#));
					</cfoutput>
	     		</cfcase>
	
	     		<cfcase value="hierarchical">
					<cfoutput>map.addControl(new GHierarchicalMapTypeControl(#sSizeMapControl#));
					</cfoutput>
				</cfcase>
	
	     		<cfdefaultcase>
					<cfoutput>map.addControl(new GMapTypeControl(#sSizeMapControl#));
					</cfoutput>
				</cfdefaultcase>

     		</cfswitch>
			
		</cfif>
		
		<cfoutput>map.addMapType(G_PHYSICAL_MAP);
		</cfoutput>
		
		<cfif isBoolean(attributes.stParam.bDisplayScaleControl) AND attributes.stParam.bDisplayScaleControl>
			<cfoutput>map.addControl(new GScaleControl());
			</cfoutput>
		</cfif>
		
		<cfif isBoolean(attributes.stParam.bDisplayMapControl) AND attributes.stParam.bDisplayMapControl>
      	<cfswitch expression="#attributes.stParam.SizeMapControl#">

      		<cfcase value="small">
					<cfoutput>map.addControl(new GSmallMapControl());		//add a small map control to the map
					</cfoutput>
      		</cfcase>

      		<cfcase value="large">
					<cfoutput>map.addControl(new GLargeMapControl());		//add a large map control to the map
					</cfoutput>
      		</cfcase>

      		<cfdefaultcase></cfdefaultcase>
      	</cfswitch>
		</cfif>

		<cfif isBoolean(attributes.stParam.bOverviewMapControl) AND attributes.stParam.bOverviewMapControl>
			<cfif attributes.stParam.OverviewWidth GT 0 AND attributes.stParam.OverviewHeight GT 0>
				<cfoutput>map.addControl(new GOverviewMapControl(new GSize(#attributes.stParam.OverviewWidth#,#attributes.stParam.OverviewHeight#)));	//add a small preview to the map
				</cfoutput>
			<cfelse>
				<cfoutput>map.addControl(new GOverviewMapControl());	//add a small preview to the map
				</cfoutput>
			</cfif>
		</cfif>
		
		<!--- miscellaneous map options --->
		<cfset lMiscOptions = "GoogleBar,ScrollWheelZoom,ContinuousZoom,DoubleClickZoom" />
		<cfloop list="#lMiscOptions#" index="i">
			<cfset iItem = attributes.stParam["bEnable#i#"] />
			<cfif isBoolean(iItem) AND iItem>
				<cfoutput>map.enable#i#();
				</cfoutput>
			</cfif>
		</cfloop>
		
		<cfif isBoolean(attributes.stParam.bEnableGKeyboardHandler)>
			<cfoutput>new GKeyboardHandler(map);
			</cfoutput>
		</cfif>
		
		<!--- TODO 20080103 whiterd | Is it possible to disable copyright for small (pixel) sized maps (< 400px wide>)? --->
			
	</cfsavecontent>


	<!--- We only want to place the google maps js file once in the header. This wll allow for 2 maps to be placed on the 1 page. --->
	<skin:htmlhead id="googleMapsAPI">
		<cfoutput><script src="http://maps.google.com/maps?file=api&amp;v=3.x&amp;key=#attributes.key#" type="text/javascript"></script></cfoutput>
	</skin:htmlhead>

	<!--- generate the map javascript and place the map javascript in the page header --->
	<!--- TODO 20071221 whiterd | Ability to have more than one map on the same page --->
	<skin:htmlhead>
	<cfoutput>
	<script type="text/javascript">
   	//<![CDATA[

		var address = null;	// used if we are geoCoding
		var zoomLevel = #attributes.stParam.zoomLevel#;
		var map = null;
		var bounds = null;
		var geocoder = null;
		
		var aGMarkers = []; // keep an array of markers
		var aHTML = []; // keep an array of marker's HTML
		var markerCounter = 0;
		
		// Directions
		var aDirectionsToHTML = [];
      var aDirectionsFromHTML = [];
		
		// functions that open the directions forms
		function directionsToHere(i) {
			aGMarkers[i].openInfoWindowHtml(aDirectionsToHTML[i]);
		}
		function directionsFromHere(i) {
			aGMarkers[i].openInfoWindowHtml(aDirectionsFromHTML[i]);
		}

		// recentre map and move marker to new centre
		function panToLatLong(sLat, sLng, sHTML) {
			if (GBrowserIsCompatible()) {
				oPnt = new GLatLng(sLat,sLng);
				<cfif attributes.stParam.bDisplayInfoWindow>
				map.showMapBlowup(oPnt);
				<cfelse>
				map.panTo(oPnt);
				</cfif>
			}
		}
		
		// This function simulates a user click on a marker and opens the corresponding info window
		function clickGMarker(i) {
			GEvent.trigger(aGMarkers[i], "click");
		}
		function setCenter(longa,Lata, zoom){
			map.setCenter(new GLatLng(longa, Lata), zoom);	
		}
		
		// Creates a marker at the given point with the given info window onclick
		function createMarker(GPoint, sHTML, GIcon, sTitle) {
									
			<cfif attributes.stParam.bShowDirectionsLink><!--- Show links for Driving Directions (links to Google Maps session) --->
				// The info window version with the "to here" form open
	        aDirectionsToHTML[markerCounter] = sHTML + '<div class="gm-dir-from">Directions: <strong>To here</strong> - <a href="##" onclick="directionsFromHere(' + markerCounter + '); return false">From here</a>' +
	           '<form  action="http://maps.google.com/maps" method="get" target="_blank">' +
	           '<label for="saddr">Start address<input type="text" size="30" name="saddr" id="saddr" value="" /></label>' +
	           '<input value="Get Directions" type="submit" />' +
	           '<input type="hidden" name="daddr" value="' + GPoint.lat() + ',' + GPoint.lng() + 
	           '"/></div>';
	           
	        // The info window version with the "to here" form open
	        aDirectionsFromHTML[markerCounter] = sHTML + '<div class="gm-dir-to">Directions: <a href="##" onclick="directionsToHere(' + markerCounter + '); return false">To here</a> - <strong>From here</strong>' +
	           '<form action="http://maps.google.com/maps" method="get" target="_blank">' +
	           '<label for="daddr">End address<input type="text" size="30" name="daddr" id="daddr" value="" /></label>' +
	           '<input value="Get Directions" type="submit" />' +
	           '<input type="hidden" name="saddr" value="' + GPoint.lat() + ',' + GPoint.lng() +
	           '"/></div>';
				
				// The inactive version of the direction info
				sHTML = sHTML + '<div class="gm-dir-menu">Directions: <a href="##" onclick="directionsToHere(' + markerCounter + '); return false">To here</a> - <a href="##" onclick="directionsFromHere(' + markerCounter + '); return false">From here</a></div>';
			</cfif>
			
			var marker = new GMarker(GPoint, {icon: GIcon, title: sTitle});
			GEvent.addListener(marker, "click", function() {
				marker.openInfoWindowHtml(sHTML);
			});
			
			bounds.extend(GPoint); // Each time a point is added, extent the map's bounds (extent) to include it
						
			aHTML[markerCounter] = sHTML;
			aGMarkers[markerCounter] = marker;
			
			markerCounter++;
			return marker;
		}

		// Creates an icon given the URL and height and width of the icon
		function createIcon(sIconURL,iIconHeight,iIconWidth) {
			var oIcon = new GIcon();
			oIcon.image = sIconURL;
			oIcon.iconSize = new GSize(iIconWidth, iIconHeight); // anchor the centre of the icon to the point
			oIcon.iconAnchor = new GPoint(iIconWidth/2,iIconHeight/2); // anchor the info window to the centre and 1/5 of the way down the icon.
			oIcon.infoWindowAnchor = new GPoint(iIconWidth/2,iIconHeight/5);
			return oIcon;
		}

		function loadGoogleMap()	//loads a google map
		{
			if (GBrowserIsCompatible())
			{
				map = new GMap2(document.getElementById("#attributes.stParam.displayDivId#"));
				//map controls as chosen in Farcry
				#mapControls#
					// ==== It is necessary to make a setCenter call of some description before adding markers ====
      		// ==== At this point we dont know the real values ====
      		// ==== We will also set the default map type (G_MAP_TYPE/G_SATELLITE_TYPE/G_HYBRID_TYPE) ====
      		map.setCenter(new GLatLng(0,0),zoomLevel,#attributes.stParam.mapType#);

      		// ===== Start with an empty GLatLngBounds object =====
      		// ===== The map bounds will be enlarged as markers are added to the map. The map will automatically set the zoom level and centre point based of the extents of the markers =====
				bounds = new GLatLngBounds();
				</cfoutput>

				<cfif not attributes.stParam.bDisplayInfoWindow>
					<cfoutput>map.disableInfoWindow();
					</cfoutput>
				</cfif>

				<cfif structKeyExists(attributes.stParam, "aLocations") >

					<cfloop from="1" to="#arrayLen(attributes.stParam.aLocations)#" index="i">
						
						<cfset stMapLocation = oMapLocation.getData(objectid=attributes.stParam.aLocations[i]) />
						
						<cfif NOT structKeyExists(stMapLocation, "teaser") OR NOT len(stMapLocation.teaser)>
							<cfset stMapLocation.teaser = stMapLocation.geoCode />
						<cfelse>
							<skin:view objectid="#attributes.stParam.aLocations[i]#" typename="googleMapLocation" template="displayInfoWindow" r_html="stMapLocation.teaser"/>
						</cfif>

						<cfif isDefined("stMapLocation.Icon") and len(trim(stMapLocation.Icon))>  // create an icon object for this location.
							<cfset stIconDetail = oMapLocation.getIconDetail(objectID=stMapLocation.icon) />
							<cfoutput>thisIcon = createIcon('#stIconDetail.IconURL#',#stIconDetail.height#,#stIconDetail.width#);
							</cfoutput>
						<cfelse>
							<cfoutput>var thisIcon = "";
							</cfoutput>
						</cfif>
						
						<!--- use latlong field in preference to geoCode --->
						<cfif len(trim(stMapLocation.latLong))><!--- there is a long/lat --->
							
							<cfoutput>
							var point = new GLatLng(#stMapLocation.latLong#);
							map.addOverlay(createMarker(point, "#JSStringFormat(trim(stMapLocation.teaser))#", thisIcon, "#stMapLocation.title#"));
							</cfoutput>
						
						<cfelseif len(trim(stMapLocation.GeoCode))><!--- there is a physical address...try geocoding to generate the map---> 

							<cfoutput>
							address = '#JSStringFormat(trim(stMapLocation.GeoCode))#';	//the address to plot

							var geocoder = new GClientGeocoder();
							geocoder.getLatLng(address,
				       			function(point)
				       			{
				       				if (!point) {
				    	   		   	alert(address + " not found");
				       				} else {
											map.addOverlay(createMarker(point, "#JSStringFormat(trim(stMapLocation.teaser))#", thisIcon, "#stMapLocation.title#"));
					         		}
					       		}
					       	);
							</cfoutput>

						</cfif>


					</cfloop>

				</cfif>

		<cfoutput>
			// ===== determine the zoom level from the bounds =====
			if (map.getBoundsZoomLevel(bounds) < map.getZoom()) {
				map.setZoom(map.getBoundsZoomLevel(bounds));
			} else {
				map.setZoom(zoomLevel);
			}
			// ===== determine the centre from the bounds ======
         map.setCenter(bounds.getCenter());
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
<!--- 		<noscript><p><strong>JavaScript must be enabled in order for you to use Google Maps.</strong> 
      However, it seems JavaScript is either disabled or not supported by your browser. 
      To view Google Maps, enable JavaScript by changing your browser options, and then 
      try again.</p>
    </noscript> --->
		<div id="#attributes.stParam.displayDivId#" class="gm-map" style="width:#attributes.stParam.width#px;height:#attributes.stParam.height#px"></div>
	</cfoutput>
	
	<cfif attributes.stParam.bDisplayMarkerList OR attributes.stParam.bShowGoogleEarthLink>
		<cfoutput><div id="#attributes.stParam.displayDivId#-toc" class="gm-toc"></cfoutput>
		
		<cfif len(trim(attributes.stParam.title))>
			<h2>#attributes.stParam.title#</h2>
		</cfif>
		
		<cfoutput><ul></cfoutput>
		
		<cfif attributes.stParam.bDisplayMarkerList>
			<cfset TMPLISTCOUNTER = 0 />
			<cfloop list="#arrayToList(attributes.stParam.aLocations)#" index="i">
				<cfset stMapLocation = oMapLocation.getData(objectid=i) />
				<cfif len(trim(stMapLocation.latLong)) OR len(trim(stMapLocation.GeoCode))><!--- if no geocode or latLong point will not be the map --->
					<!--- Alternate window method (just pans doesn't open info window) <li><a href="##" onclick="panToLatLong(#stMapLocation.LATLONG#)" title="Pan to #stMapLocation.TITLE#">#stMapLocation.TITLE#</a></li>--->
					<cfoutput>
						<li>
							<a href="##" onclick="clickGMarker(#TMPLISTCOUNTER#); return false;" title="Show #stMapLocation.TITLE#">#stMapLocation.TITLE#</a>
						</li>
					</cfoutput>
					<cfset TMPLISTCOUNTER = TMPLISTCOUNTER + 1 />
				</cfif>
			</cfloop>
		</cfif>	
		
		<cfif attributes.stParam.bShowGoogleEarthLink>
			<cfoutput><li><a href="/googleMaps/mapFeed.cfm?objectid=#attributes.stParam.objectid#" class="link-kml" >Show in Google Earth</a></li>
			</cfoutput>
		</cfif>
	
			
			<cfoutput></ul></div></cfoutput>
		
	</cfif>

	<!--- <cfif attributes.stParam.bShowDirectionsLink>
		<cfoutput>
			<div id="#attributes.stParam.displayDivId#-dir-list" style="overflow:auto;height:390px" class="gm-dir-list"></div>
		</cfoutput>
	</cfif> --->
	
</cfif>

<cfif thistag.executionMode eq "end">
	<cfexit method="EXITTAG" />
</cfif>

<cfsetting enablecfoutputonly="no" />