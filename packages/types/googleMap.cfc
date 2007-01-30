<cfcomponent extends="farcry.farcry_core.packages.types.types" displayName="Google Map" hint="Google Map" bFriendly="1" bobjectbroker="true" objectbrokermaxobjects="1000">
	
	<!------------------------------------------------------------------------
	type properties
	------------------------------------------------------------------------->	
	<cfproperty ftSeq="1" ftFieldSet="Map Title" name="Title" bLabel="true" type="string" hint="Title of the google map, used for Object Admin" required="true" ftLabel="Title" ftType="string" />
	<cfproperty ftSeq="2" ftFieldSet="Locations" name="aLocations" type="array" hint="Different locations to plot on a map content object" ftLabel="Locations" ftType="array" ftJoin="GoogleMapLocation" />
	<cfproperty ftSeq="3" ftFieldSet="Locations" name="centerLocationID" type="uuid" hint="Location to Center Map on" ftLabel="Center Location" ftType="uuid" ftJoin="GoogleMapLocation" />
	
	<cfproperty ftSeq="10" ftFieldSet="Dimensions" name="Height" type="numeric" hint="Height of the map" ftRequired="false" ftLabel="Height" ftType="numeric" ftIncludeDecimal="false" />
	<cfproperty ftSeq="11" ftFieldSet="Dimensions" name="Width" type="numeric" hint="Width of the map" ftRequired="false" ftLabel="Width" ftType="numeric" ftIncludeDecimal="false" />
	<cfproperty ftSeq="12" ftFieldSet="Dimensions" name="Zoom" type="numeric" hint="Zoom level of the map" ftRequired="false" ftLabel="Zoom Level (max 17)" ftType="numeric" ftIncludeDecimal="false" Default="13">

	
	<!------------------------------------------------------------------------
	object methods 
	------------------------------------------------------------------------->	

		
</cfcomponent>