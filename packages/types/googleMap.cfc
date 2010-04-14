<cfcomponent extends="farcry.core.packages.types.types" displayName="Google Map" hint="Google Maps" bFriendly="1" bobjectbroker="true" objectbrokermaxobjects="1000">
	
	<!------------------------------------------------------------------------
	type properties
	------------------------------------------------------------------------->	
	<cfproperty ftSeq="1" ftFieldSet="Map Title" name="title" bLabel="true" type="string" hint="Title of the google map, used for Object Admin" required="true" ftLabel="Title" ftType="string" />
	<cfproperty ftSeq="2" ftFieldSet="Locations" name="aLocations" type="array" hint="Different locations to plot on a map content object" ftLabel="Locations" ftType="array" ftJoin="googleMapLocation" ftAllowLibraryEdit="true" />
	
	<!--- map dimensions --->
	<cfproperty ftSeq="10" ftFieldSet="Dimensions" name="width" type="integer" hint="Width of the map" ftRequired="false" ftLabel="Width" ftDefault="400" ftType="integer" ftValidation="required,validate-number" />
	<cfproperty ftSeq="11" ftFieldSet="Dimensions" name="height" type="integer" hint="Height of the map" ftRequired="false" ftLabel="Height" ftDefault="400" ftType="integer" ftValidation="required,validate-number" />
	<cfproperty ftSeq="12" ftFieldSet="Dimensions" name="sizeMapControl" type="string" hint="Size of map controls ('small' or 'large')" ftRequired="false" ftDefault="Large" ftLabel="Size of Map Controls" ftType="list" ftList="Large,Small" ftRenderType="dropdown" />

	<!------------------------------------------------------------------------
	GOOGLE MAP OPTIONS
	------------------------------------------------------------------------->	

	<!--- Map Type Control --->
	<cfproperty ftSeq="15" ftFieldSet="Map Type" name="bMapTypeControl" type="boolean" hint="Flag to indicate to display the Map Type control" ftRequired="false" ftDefault="1" ftLabel="Display Map Type Control" ftType="boolean" />
	<cfproperty ftSeq="16" ftFieldSet="Map Type" name="mapTypeControlFormat" type="string" hint="Format of Map Type control" ftRequired="false" ftDefault="" ftLabel="Format of Map Type Control" ftType="list"  ftList="Normal,Menu:Menu (undocumented),Hierarchical" ftRenderType="dropdown" />
	<cfproperty ftSeq="17" ftFieldSet="Map Type" name="mapType" type="string" hint="Set the default Map Type 'hybrid/satellite/map/relief'" ftRequired="false" ftDefault="G_MAP_TYPE" ftLabel="Default Map Type" ftType="list" ftList="G_NORMAL_MAP:Map,G_SATELLITE_MAP:Satellite,G_HYBRID_MAP:Hybrid,G_PHYSICAL_MAP:Relief" ftRenderType="dropdown" />
	
	<!--- Other Map Controls --->
	<cfproperty ftSeq="20" ftFieldSet="Other Map Controls" name="bDisplayMapControl" type="boolean" hint="Flag to indicate to display the Map (zoom/pan) Control" required="no" default="1" ftRequired="false" ftLabel="Display Map Control (zoom/pan)" ftType="boolean" />
	<cfproperty ftSeq="21" ftFieldSet="Other Map Controls" name="bDisplayScaleControl" type="boolean" hint="Flag to indicate to display the Scale Control" required="no" default="0" ftRequired="false" ftLabel="Display Scale Control" ftType="boolean" />
	<cfproperty ftSeq="24" ftFieldSet="Other Map Controls" name="zoomLevel" type="integer" hint="The minimum initial zoom level of the map" ftRequired="false" ftDefault="13" ftLabel="Minimum Initial Zoom Level" ftType="list" ftList="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16" ftRenderType="dropdown" />

	<!--- Map Marker Options --->
	<cfproperty ftSeq="25" ftFieldSet="Marker/Location Options" name="bDisplayMarkerList" type="boolean" hint="Flag to indicate to display a Marker list (Table of Contents) with zoom to links" required="no" default="0" ftRequired="false" ftLabel="Display Marker List" ftType="boolean" />
	<cfproperty ftSeq="26" ftFieldSet="Marker/Location Options" name="bDisplayInfoWindow" type="boolean" hint="Flag to indicate to display the information (Bubble) window in Google Maps" required="no" default="1" ftRequired="false" ftDefault="1" ftLabel="Display Info Window for markers" ftType="boolean" />

	<!--- overview map control --->
	<cfproperty ftSeq="30" ftFieldSet="Overview Map Control" name="bOverviewMapControl" type="boolean" hint="Flag to indicate to display the overview map control" ftRequired="false" ftDefault="1" ftLabel="Overview Map Control" ftType="boolean" />	
	<cfproperty ftSeq="31" ftFieldSet="Overview Map Control" name="overviewWidth" type="integer" hint="Width of the overview map control" ftRequired="false" ftDefault="100" ftLabel="Map Control Width" ftType="integer" ftValidation="validate-number" />	
	<cfproperty ftSeq="32" ftFieldSet="Overview Map Control" name="overviewHeight" type="integer" hint="Height of the overview map control" ftRequired="false" ftDefault="100" ftLabel="Map Control Height" ftType="integer" ftValidation="validate-number" />			

	<!--- Miscellaneous Map Options --->
	<cfproperty ftSeq="36" ftFieldSet="Miscellaneous Options" name="bEnableGoogleBar" type="boolean" hint="Flag to indicate to display the GoogleBar" ftRequired="false" ftDefault="0" ftLabel="Enable GoogleBar" ftType="boolean" />	
	<cfproperty ftSeq="37" ftFieldSet="Miscellaneous Options" name="bEnableScrollWheelZoom" type="boolean" hint="Flag to indicate to zooming via the mouse scroll wheel" ftRequired="false" ftDefault="0" ftLabel="Enable ScrollWheelZoom" ftType="boolean" />	
	<cfproperty ftSeq="38" ftFieldSet="Miscellaneous Options" name="bEnableContinuousZoom" type="boolean" hint="Flag to indicate to enable ContinuousZoom" ftRequired="false" ftDefault="0" ftLabel="Enable ContinuousZoom" ftType="boolean" />	
	<cfproperty ftSeq="39" ftFieldSet="Miscellaneous Options" name="bEnableDoubleClickZoom" type="boolean" hint="Flag to indicate to enable DoubleClickZoom" ftRequired="false" ftDefault="0" ftLabel="Enable DoubleClickZoom" ftType="boolean" />	
	<cfproperty ftSeq="40" ftFieldSet="Miscellaneous Options" name="bEnableGKeyboardHandler" type="boolean" hint="Flag to indicate to enable GKeyboardHandler" ftRequired="false" ftDefault="0" ftLabel="Enable GKeyboardHandler" ftType="boolean" />	
	<cfproperty ftSeq="41" ftFieldSet="Miscellaneous Options" name="bShowDirectionsLink" type="boolean" hint="Flag to indicate to show a Google Driving direction" ftRequired="false" ftDefault="0" ftLabel="Show Driving Directions" ftType="boolean" />	
	<cfproperty ftSeq="42" ftFieldSet="Miscellaneous Options" name="bShowGoogleEarthLink" type="boolean" hint="Flag to indicate to show a link to Google Earth" ftRequired="false" ftDefault="0" ftLabel="Show Google Earth link (requires virtual directory)" ftType="boolean" />	


	<!------------------------------------------------------------------------
	object methods
	------------------------------------------------------------------------->	

 	<cffunction name="ftDisplayHeight" access="public" output="false" returntype="string" hint="This will return the google map height with the default.">
		<cfargument name="typename" required="true" type="string" hint="The name of the type that this field is part of." />
		<cfargument name="stObject" required="true" type="struct" hint="The object of the record that this field is part of." />
		<cfargument name="stMetadata" required="true" type="struct" hint="This is the metadata that is either setup as part of the type.cfc or overridden when calling ft:object by using the stMetadata argument." />
		<cfargument name="fieldname" required="true" type="string" hint="This is the name that will be used for the form field. It includes the prefix that will be used by ft:processform." />

		<cfset result = trim(stmetadata.value) />
		<cfif not len(result) or not isNumeric(result)>
			<cfset result = stMetadata.default />
		</cfif>	

		<cfreturn numberFormat(result) />
	</cffunction>

</cfcomponent>