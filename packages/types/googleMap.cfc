<cfcomponent extends="farcry.farcry_core.packages.types.types" displayName="Google Map" hint="Google Map" bFriendly="1" bobjectbroker="true" objectbrokermaxobjects="1000">
	
	<!------------------------------------------------------------------------
	type properties
	------------------------------------------------------------------------->	
	<cfproperty ftSeq="1" ftFieldSet="Map Title" name="Title" bLabel="true" type="string" hint="Title of the google map, used for Object Admin" required="true" ftLabel="Title" ftType="string" />
	<cfproperty ftSeq="2" ftFieldSet="Locations" name="aLocations" type="array" hint="Different locations to plot on a map content object" ftLabel="Locations" ftType="array" ftJoin="googleMapLocation" />
	
	<!--- map dimensions --->
	<cfproperty ftSeq="10" ftFieldSet="Dimensions" name="Height" type="numeric" hint="Height of the map" ftRequired="false" ftLabel="Height" ftType="numeric" ftIncludeDecimal="false" ftValidation="validate-number" />
	<cfproperty ftSeq="11" ftFieldSet="Dimensions" name="Width" type="numeric" hint="Width of the map" ftRequired="false" ftLabel="Width" ftType="numeric" ftIncludeDecimal="false" ftValidation="validate-number" />

	<!--- google map options --->
	<cfproperty ftSeq="15" ftFieldSet="Map Options" name="ZoomLevel" type="numeric" hint="The default zoom level of the map" ftRequired="false" ftDefault="13" ftLabel="Zoom Level" ftType="list" ftList="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16" ftRenderType="dropdown" />
	<cfproperty ftSeq="16" ftFieldSet="Map Options" name="bMapTypeControl" type="boolean" hint="Whether to load the 'hybrid/satellite/map' control" ftRequired="false" ftDefault="false" ftLabel="Map Type (Map/Satellite/Hybrid)" ftType="boolean" />
	<cfproperty ftSeq="17" ftFieldSet="Map Options" name="SizeMapControl" type="string" hint="Whether to have and what type of map control (small or large etc)" ftRequired="false" ftDefault="" ftLabel="Map Control" ftType="list" ftList="--,small,large" ftRenderType="dropdown" />
	<cfproperty ftSeq="18" ftFieldSet="Map Options" name="bOverviewMapControl" type="boolean" hint="Whether to have the overview map control" ftRequired="false" ftDefault="" ftLabel="Overview Map Control" ftType="boolean" />	
	<cfproperty ftSeq="19" ftFieldSet="Map Options" name="OverviewWidth" type="numeric" hint="Width of the overview map control" ftRequired="false" ftDefault="" ftLabel="Map Control Width" ftType="numeric" ftIncludeDecimal="false" ftValidation="validate-number" />	
	<cfproperty ftSeq="20" ftFieldSet="Map Options" name="OverviewHeight" type="numeric" hint="Height of the overview map control" ftRequired="false" ftDefault="" ftLabel="Map Control Height" ftType="numeric" ftIncludeDecimal="false" ftValidation="validate-number" />			
	
	<!------------------------------------------------------------------------
	object methods 
	------------------------------------------------------------------------->	

		
</cfcomponent>