<cfcomponent extends="farcry.farcry_core.packages.types.types" displayName="Google Map Location" hint="Google Map Location" bFriendly="1" bobjectbroker="true" objectbrokermaxobjects="1000">
	
	<!------------------------------------------------------------------------
	type properties
	------------------------------------------------------------------------->	
	<cfproperty ftSeq="1" ftFieldSet="Details" name="Title" bLabel="true" type="string" hint="Title of the location" required="true" ftLabel="Title" ftType="string" />
	<cfproperty ftSeq="2" ftFieldSet="Details" name="Teaser" type="longchar" hint="Description of the location" required="false" ftLabel="Location Description" ftType="richtext" />
	<cfproperty ftSeq="3" ftFieldSet="Longitude and Latitude" name="LongLat" type="string" hint="Longitude and latitude of the map location" required="true" ftLabel="Longitude and Latitude" ftType="string" />

	<!------------------------------------------------------------------------
	object methods 
	------------------------------------------------------------------------->	

		
</cfcomponent>



