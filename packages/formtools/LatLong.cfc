<cfcomponent extends="farcry.core.packages.formtools.string" name="LatLong" displayname="LatLong" hint="Extends 'string' to hold latLong coords for Google Maps"> 

	<cffunction name="init" access="public" returntype="farcry.plugins.googleMaps.packages.formtools.LatLong" output="false" hint="Returns a copy of this initialised object">
		
		<cfreturn this />
		
	</cffunction>
	
	<cffunction name="edit" access="public" output="true" returntype="string" hint="his will return a string of formatted HTML text to enable the user to edit the data">
		<cfargument name="typename" required="true" type="string" hint="The name of the type that this field is part of." />
		<cfargument name="stObject" required="true" type="struct" hint="The object of the record that this field is part of." />
		<cfargument name="stMetadata" required="true" type="struct" hint="This is the metadata that is either setup as part of the type.cfc or overridden when calling ft:object by using the stMetadata argument." />
		<cfargument name="fieldname" required="true" type="string" hint="This is the name that will be used for the form field. It includes the prefix that will be used by ft:processform." />

		<cfimport taglib="/farcry/core/tags/webskin/" prefix="skin" />
		<skin:htmlHead id="googleMapsAPI">
		<cfoutput><script src="//maps.google.com/maps?file=api&amp;v=2.x&amp;key=#application.config.googleMaps.apiKey#" type="text/javascript"></script>
		</cfoutput>
		</skin:htmlHead>
		
		<skin:htmlHead id="googleMapsAPI_LatLongHandling">
		<cfoutput><script type="text/javascript">
	   //<![CDATA[
	   	//Utility function used by geoAddress FormTool
			function updateLatLngInput(sFieldID, newLat, newLng) {
				document.getElementById(sFieldID).value = newLat + ", " + newLng;
			}
			
			<!--- if (aNewPnt.length == 2 || ) {
						alert(sNewPnt);
					} else { --->
			/* a few checks to ensure a string can be made into a valid lat/long
			   valid strings are in the form: a,a
			   Where a:
			   	can start with an (optional)hyhen/minus sign
			   	must be a (foating point) number between 0 and 180
			*/
			function isStringValidLatLong(sString) {
				var sLatLongExp = /\s*-?[0-9]{1,3}\.?[0-9]*\s*/;
				var aTest = sString.split(",");
				
				if (aTest.length == 2 && aTest[0].length > 0 && aTest[0].match(sLatLongExp) && aTest[1].length > 0 && aTest[1].match(sLatLongExp)) {
					return true;
				} else {
					return false;
				}
			}
					
			// pan map to specificed location
			function panToLatLong(sNewPnt) { //Utility function also used by geoAddress FormTool's text input
				if ( GBrowserIsCompatible() ) {
					if ( isStringValidLatLong(sNewPnt) ) {
						//sNewPnt should be passed in as a string in the form: "lat,long" - need to split to create a new GLatLng point
						var aNewPnt = sNewPnt.split(",");
						var oPnt = new GLatLng(aNewPnt[0],aNewPnt[1]);
						marker.setLatLng(oPnt);
						map.panTo(oPnt);
					} else {
						alert("Invalid point: This doesn't look like a valid Google location point");
					}
				}
			}
			
			// recentre a map using the marker location
			function findMarker() {
				if (GBrowserIsCompatible()) {
					if (marker!=null && map!=null) {
						map.panTo(marker.getLatLng());
					}
				}
			}
			// recentre a map and move marker to new centre
			function centreMarker(sFieldID) {
				if ( GBrowserIsCompatible() ) {
					if (marker!=null && map!=null) {
						marker.setLatLng( map.getCenter() );
						updateLatLngInput( sFieldID, marker.getPoint().lat(), marker.getPoint().lng() );
					}
				}
			}
		//]]>
		</script>
		</cfoutput>
		</skin:htmlHead>
		
		<skin:htmlHead id="googleMapsAPI_mapLoadingUnloading">
		<cfoutput><script type="text/javascript">
	   //<![CDATA[
	   	//using onunload() to prevent memory leaks especially in IE
    		window.onunload = function() {
    			GUnload();
    		}
    
    		// load google maps
    		window.onload = function() {
	    		loadGoogleMap();	
    		}
    		</script>
		</cfoutput>
		</skin:htmlHead>
		
		<cfsavecontent variable="html">
			<cfoutput><input type="text" name="#arguments.fieldname#" id="#arguments.fieldname#" value="#HTMLEditFormat(arguments.stMetadata.value)#" class="#arguments.stMetadata.ftclass#" style="#arguments.stMetadata.ftstyle#" onchange="panToLatLong(this.value)" /></cfoutput>
			
			<cfif isDefined("application.config.googleMaps.apiKey")>
				<cfoutput>
				<div id="map" style="width: 400px; height: 300px"></div>
				<a href="##" onclick="findMarker(); return false">Find Marker</a>
				<a href="##" onclick="centreMarker('#arguments.fieldname#'); return false">Move marker to map centre</a>
				
				<script type="text/javascript">	
					var map = null;
					var marker = null;
					
					function loadGoogleMap() {
						if (GBrowserIsCompatible()) {
							map = new GMap2(document.getElementById("map"));
							map.addControl(new GSmallMapControl());
							map.addControl(new GMapTypeControl());
							map.enableScrollWheelZoom();
							<cfif len(trim(arguments.stMetadata.value))>
								<cfset sPointLatLong = arguments.stMetadata.value />
							<cfelse>
								<cfset sPointLatLong = "-33.871841,151.227922" /><!--- choose default location (Daemon HQ) for map - does not affect object's location --->
							</cfif>
							var center = new GLatLng(#sPointLatLong#);
							map.setCenter(center, 13);
							marker = new GMarker(center, {draggable: true, bouncy: true, autoPan: true, title: "Drag me to your desired location"});
							map.addOverlay(marker);
						}
						
						GEvent.addListener(marker, "dragend", function() {
							var newLat = marker.getPoint().lat();
							var newLng = marker.getPoint().lng();
							//alert("newlat" + newLat + ", newlng" + newLng);
							<!--- TODO 20080104 whiterd | truncate coords to (Google default) 6 decimal places - accurate to 4 inches/ 11 centimeters) --->
							updateLatLngInput("#arguments.fieldname#",newLat,newLng);
							map.panTo(marker.getPoint());
						});
					}
				</script>
				</cfoutput>
			</cfif>
		</cfsavecontent>
		
		<cfreturn html />
	</cffunction>


	<cffunction name="display" access="public" output="false" returntype="string" hint="This will return a string of formatted HTML text to display.">
		<cfargument name="typename" required="true" type="string" hint="The name of the type that this field is part of." />
		<cfargument name="stObject" required="true" type="struct" hint="The object of the record that this field is part of." />
		<cfargument name="stMetadata" required="true" type="struct" hint="This is the metadata that is either setup as part of the type.cfc or overridden when calling ft:object by using the stMetadata argument." />
		<cfargument name="fieldname" required="true" type="string" hint="This is the name that will be used for the form field. It includes the prefix that will be used by ft:processform." />

		
		<cfsavecontent variable="html">
			<cfoutput>#arguments.stMetadata.value#</cfoutput>
		</cfsavecontent>
		
		<cfreturn html />
	</cffunction>


	<cffunction name="validate" access="public" output="false" returntype="struct" hint="This will return a struct with bSuccess and stError">
		<cfargument name="stFieldPost" required="true" type="struct" hint="The fields that are relevent to this field type." />
		<cfargument name="stMetadata" required="true" type="struct" hint="This is the metadata that is either setup as part of the type.cfc or overridden when calling ft:object by using the stMetadata argument." />
		
		<!--- TODO 20080103 whiterd | could use GM API to create then validate as a GPoint --->
		<cfset var stResult = structNew() />		
		<cfset stResult.bSuccess = true />
		<cfset stResult.value = "" />
		<cfset stResult.stError = StructNew() />
		
		<!--- --------------------------- --->
		<!--- Perform any validation here --->
		<!--- --------------------------- --->
		<cfset stResult.value = stFieldPost.Value />
		
		
		<!--- ----------------- --->
		<!--- Return the Result --->
		<!--- ----------------- --->
		<cfreturn stResult />
		
	</cffunction>
	
</cfcomponent> 