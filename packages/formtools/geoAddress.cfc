<cfcomponent extends="farcry.core.packages.formtools.string" name="geoAddress" displayname="google map address" hint="Extends 'string' to hold address for Google Maps"> 
	
	<cffunction name="init" access="public" returntype="farcry.plugins.googleMaps.packages.formtools.geoAddress" output="false" hint="Returns a copy of this initialised object">
		
		<cfreturn this />
		
	</cffunction>

	<cffunction name="edit" access="public" output="true" returntype="string" hint="his will return a string of formatted HTML text to enable the user to edit the data">
		<cfargument name="typename" required="true" type="string" hint="The name of the type that this field is part of.">
		<cfargument name="stObject" required="true" type="struct" hint="The object of the record that this field is part of.">
		<cfargument name="stMetadata" required="true" type="struct" hint="This is the metadata that is either setup as part of the type.cfc or overridden when calling ft:object by using the stMetadata argument.">
		<cfargument name="fieldname" required="true" type="string" hint="This is the name that will be used for the form field. It includes the prefix that will be used by ft:processform.">

		<cfimport taglib="/farcry/core/tags/webskin/" prefix="skin" />
		<skin:htmlHead id="googleMapsAPI">
		<cfoutput>
		<script src="http://maps.google.com/maps?file=api&amp;v=2.x&amp;key=#application.config.googleMaps.apiKey#" type="text/javascript"></script></cfoutput>
		</skin:htmlHead>
		
		<skin:htmlHead id="googleMaps_geoAddressHandling">
		<cfoutput>
		<script type="text/javascript">
		//<![CDATA[
		var geocoder = new GClientGeocoder();
		var geocoderResponseJSON = null;
		
		// ====== Array for decoding the Google's geocoding status ======
		<!--- http://code.google.com/apis/maps/documentation/reference.html -> GGeoStatusCode --->
		var aGeoStatusCodes=[];
		aGeoStatusCodes[G_GEO_SUCCESS]            = "Success";
		aGeoStatusCodes[G_GEO_MISSING_ADDRESS]    = "Missing Address: The address was either missing or had no value.";
		aGeoStatusCodes[G_GEO_UNKNOWN_ADDRESS]    = "Unknown Address: No corresponding geographic location could be found for the specified address.";
		aGeoStatusCodes[G_GEO_UNAVAILABLE_ADDRESS]= "Unavailable Address: The geocode for the given address cannot be returned due to legal or contractual reasons.";
		aGeoStatusCodes[G_GEO_BAD_KEY]            = "Bad Key: The API key is either invalid or does not match the domain for which it was given";
		aGeoStatusCodes[G_GEO_TOO_MANY_QUERIES]   = "Too Many Queries: The daily geocoding quota for this site has been exceeded.";
		aGeoStatusCodes[G_GEO_SERVER_ERROR]       = "Server error: The geocoding request could not be successfully processed.";
		
		// Attempt to geocode the supplied address
		// If successful attempt to update an associated latLong field, pan the latLong's map to the new location and update the geoAddress using the fully qualified address returned from the geocoder 
		function geocodeAddress(sAddress, sAddressFieldID, slatLongFieldID) {
			if (sAddress!=null) {
				resetInnerHTML("geocodemessage");
				//document.getElementById(sAddressFieldID).value = "Looking up geo-codes...";
				<!--- the geocode returns a JSON object (see http://doug.ricket.com/geoweb/examples/ example 16 for format). This function previously used geocoder.getLatLng which only passes back the GPoint not the full record --->
				if (geocoder) {
					geocoder.getLocations(
						sAddress,
						function(response) {
							if (!response.Status || response.Status.code != G_GEO_SUCCESS) {
								document.getElementById("geocodemessage").innerHTML = '<p class="highlight"><strong>No address found!</strong><br />' + aGeoStatusCodes[response.Status.code] + '<br />[Google error code: ' + response.Status.code + ']</p>';
							} else {
								geocoderResponseJSON = response;
								if (response.Placemark.length > 1) { // If there was more than one result, "ask did you mean"
									var sChoicesHTML = '<p class="success">Found ' + response.Placemark.length + ' addresses. Please choose one:</p><ul>';
									// Loop through the results
									for (var i=0; i<response.Placemark.length; i++) {
										// In order to make a these 'text' links need to escape quotes around the string args - this gets nasty!
										sChoicesHTML += '<li><a href="##" title="Click to select address (lat/long: ' + response.Placemark[i].Point.coordinates + ')" onclick="chooseAddress(\'' + sAddressFieldID + '\',\'' + slatLongFieldID + '\',' + i + '); return false">' + response.Placemark[i].address + '</a></li>';
									}
									sChoicesHTML += "</ul>";
									document.getElementById("geocodemessage").innerHTML = sChoicesHTML;
									//alert(document.getElementById("geocodemessage").innerHTML);
								} else {
									document.getElementById("geocodemessage").innerHTML = '<p class="success">Found your address</p>'; // would a nice to have fade this message - useful if user clicks 'Geocode Address' repeatedly 							
									var oFoundLocation = response.Placemark[0]; // getLocations may return more than one Placemark - just use the first one for the moment. 
									var oPoint = new GLatLng(oFoundLocation.Point.coordinates[1], oFoundLocation.Point.coordinates[0]);
									updateAddressField(sAddressFieldID, oFoundLocation.address); // update the address field with the full address as reported by the geocoder
									if (slatLongFieldID != 0) { // slatLongFieldID is optional
										if(updateLatLngInput) { updateLatLngInput(slatLongFieldID, oPoint.lat(), oPoint.lng()); } // attempt to update an associated latLong field
										if(panToLatLong) { panToLatLong(oPoint.lat() + ',' + oPoint.lng()); } // attempt to update an associated latLong map
									}
								}
							}
						}
					);
				}
			}
		}
		
		function updateAddressField(sAddressFieldID, sAddress) {
			if (sAddressFieldID != null || sAddress != null) {
				document.getElementById(sAddressFieldID).value = sAddress;
			}
		}
		
		function resetInnerHTML(sDOMId) {
			document.getElementById(sDOMId).innerHTML = "<p>&nbsp;</p>";//nbsp stops the jumping when geocode address is clicked repeatedly
		}
		<!--- TODO 20080103 whiterd | should be passed ID to make these functions generic and able to handle more than one geoAddress per type --->
		function chooseAddress(sAddressFieldID, slatLongFieldID, i) {
			updateAddressField(sAddressFieldID, geocoderResponseJSON.Placemark[i].address);
			resetInnerHTML("geocodemessage");
			var p = geocoderResponseJSON.Placemark[i].Point.coordinates;
			if(updateLatLngInput) { updateLatLngInput(slatLongFieldID,p[1],p[0]); } // attempt to update an associated latLong field
			if(panToLatLong) { panToLatLong(p[1] + ',' + p[0]); } // attempt to update an associated latLong field's map
		}
		//]]>
		</script>
		</cfoutput>
		</skin:htmlHead>
	
		<cfsavecontent variable="html">
			<cfoutput>
				<!--- NOTE: Unfortunately the link between the geoAddress and a the LatLong FT needs to be hard-coded this means any one type cannot have more than one latLong FT field --->
				<input type="text" name="#arguments.fieldname#" id="#arguments.fieldname#" value="#HTMLEditFormat(arguments.stMetadata.value)#" size="50" class="#arguments.stMetadata.ftclass#" style="#arguments.stMetadata.ftstyle#" onchange="geocodeAddress(this.value, '#arguments.fieldname#', '#replace(ARGUMENTS.stObject.ObjectID,'-', '', 'ALL')#LatLong'); return false" />
				<a href="##" onclick="geocodeAddress(document.getElementById('#arguments.fieldname#').value, '#arguments.fieldname#', 'fc#replace(ARGUMENTS.stObject.ObjectID,'-', '', 'ALL')#LatLong'); return false">Geocode Address</a>
				<div id="geocodemessage"><p class="subdued">Geocoded address will be updated to Google's fully qualified address format</p></div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn html />

	</cffunction>

	<cffunction name="display" access="public" output="false" returntype="string" hint="This will return a string of formatted HTML text to display.">
		<cfargument name="typename" required="true" type="string" hint="The name of the type that this field is part of.">
		<cfargument name="stObject" required="true" type="struct" hint="The object of the record that this field is part of.">
		<cfargument name="stMetadata" required="true" type="struct" hint="This is the metadata that is either setup as part of the type.cfc or overridden when calling ft:object by using the stMetadata argument.">
		<cfargument name="fieldname" required="true" type="string" hint="This is the name that will be used for the form field. It includes the prefix that will be used by ft:processform.">
		
		<cfsavecontent variable="html">
			<cfoutput>#arguments.stMetadata.value#</cfoutput>
		</cfsavecontent>
		
		<cfreturn html />
	</cffunction>

	<cffunction name="validate" access="public" output="false" returntype="struct" hint="This will return a struct with bSuccess and stError">
		<cfargument name="stFieldPost" required="true" type="struct" hint="The fields that are relevent to this field type.">
		<cfargument name="stMetadata" required="true" type="struct" hint="This is the metadata that is either setup as part of the type.cfc or overridden when calling ft:object by using the stMetadata argument.">
		
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