<cfcomponent extends="farcry.core.packages.types.types" displayName="Google Map" hint="Google Map" bFriendly="1" bobjectbroker="true" objectbrokermaxobjects="1000">
	
	<!------------------------------------------------------------------------
	type properties
	------------------------------------------------------------------------->	
	<cfproperty ftSeq="1" ftFieldSet="Map Title" name="title" bLabel="true" type="string" hint="Title of the google map, used for Object Admin" required="true" ftLabel="Title" ftType="string" />
	<cfproperty ftSeq="2" ftFieldSet="Locations" name="aLocations" type="array" hint="Different locations to plot on a map content object" ftLabel="Locations" ftType="array" ftJoin="googleMapLocation" ftAllowLibraryEdit="googleMapLocation" />
	
	<!--- map dimensions --->
	<cfproperty ftSeq="10" ftFieldSet="Dimensions" name="width" type="integer" hint="Width of the map" ftRequired="false" ftLabel="Width" ftDefault="400" ftType="integer" ftValidation="required,validate-number" />
	<cfproperty ftSeq="11" ftFieldSet="Dimensions" name="height" type="integer" hint="Height of the map" ftRequired="false" ftLabel="Height" ftDefault="400" ftType="integer" ftValidation="required,validate-number" />

	<!------------------------------------------------------------------------
	GOOGLE MAP OPTIONS
	------------------------------------------------------------------------->	
	
	<!--- Map Type Control --->
	<cfproperty ftSeq="15" ftFieldSet="Map Type" name="bMapTypeControl" type="boolean" hint="Whether to load the 'hybrid/satellite/map' control" ftRequired="false" ftDefault="1" ftLabel="Map/Satellite/Hybrid" ftType="boolean" />
	
	<!--- Map Size Control --->
	<cfproperty ftSeq="16" ftFieldSet="Map Control Size / Zoom" name="sizeMapControl" type="string" hint="Whether to have and what type of map control (small or large etc)" ftRequired="false" ftDefault="Large" ftLabel="Map Control" ftType="list" ftList="Off,Small,Large" ftRenderType="dropdown" />
	<cfproperty ftSeq="17" ftFieldSet="Map Control Size / Zoom" name="zoomLevel" type="integer" hint="The default zoom level of the map" ftRequired="false" ftDefault="13" ftLabel="Zoom Level" ftType="list" ftList="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16" ftRenderType="dropdown" />

	<!--- overview map control --->
	<cfproperty ftSeq="18" ftFieldSet="Overview Map Control" name="bOverviewMapControl" type="boolean" hint="Whether to have the overview map control" ftRequired="false" ftDefault="1" ftLabel="Overview Map Control" ftType="boolean" />	
	<cfproperty ftSeq="19" ftFieldSet="Overview Map Control" name="overviewWidth" type="integer" hint="Width of the overview map control" ftRequired="false" ftDefault="100" ftLabel="Map Control Width" ftType="integer" ftValidation="validate-number" />	
	<cfproperty ftSeq="20" ftFieldSet="Overview Map Control" name="overviewHeight" type="integer" hint="Height of the overview map control" ftRequired="false" ftDefault="100" ftLabel="Map Control Height" ftType="integer" ftValidation="validate-number" />			
	
	<!------------------------------------------------------------------------
	object methods 
	------------------------------------------------------------------------->	
	

 	<cffunction name="ftDisplayHeight" access="public" output="true" returntype="string" hint="This will return the google map height with the default.">
		<cfargument name="typename" required="true" type="string" hint="The name of the type that this field is part of.">
		<cfargument name="stObject" required="true" type="struct" hint="The object of the record that this field is part of.">
		<cfargument name="stMetadata" required="true" type="struct" hint="This is the metadata that is either setup as part of the type.cfc or overridden when calling ft:object by using the stMetadata argument.">
		<cfargument name="fieldname" required="true" type="string" hint="This is the name that will be used for the form field. It includes the prefix that will be used by ft:processform.">
				
		<cfset result = trim(stmetadata.value) />
		
		<cfif not len(result) or not isNumeric(result)>
			<cfset result = stMetadata.default />
		</cfif>	
		
		<cfreturn numberFormat(result)>
	</cffunction>
	

		
</cfcomponent>