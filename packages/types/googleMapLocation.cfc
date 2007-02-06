<cfcomponent extends="farcry.farcry_core.packages.types.types" displayName="Google Map Location" hint="Google Map Location" bFriendly="1" bobjectbroker="true" objectbrokermaxobjects="1000">
	
	<!------------------------------------------------------------------------
	type properties
	------------------------------------------------------------------------->	
	<cfproperty ftSeq="1" ftFieldSet="Details" name="Title" bLabel="true" type="string" hint="Title of the location" required="true" ftLabel="Title" ftType="string" />
	<cfproperty ftSeq="2" ftFieldSet="Details" name="Teaser" type="longchar" hint="Description of the location" required="false" ftLabel="Location Description" ftType="richtext" />
	
	<!--- GEOCODING --->
	<cfproperty ftSeq="3" ftFieldSet="Geocoding" name="Geocode" type="longchar" hint="An actual address to use geocoding to render the map" required="false" ftLabel="Physical address" ftType="longchar" />
	
	<!--- LONG/LAT --->
	<cfproperty ftSeq="4" ftFieldSet="Latitude and Longitude" name="LatLong" type="string" hint="Latitude and longitude of the map location" required="false" ftLabel="Latitude and Longitude" ftType="latLong" />

	<!------------------------------------------------------------------------
	object methods 
	------------------------------------------------------------------------->	

		
</cfcomponent>