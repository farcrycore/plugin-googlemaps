<!--- @@Copyright: Daemon Pty Limited 2002-2008, http://www.daemon.com.au --->
<!--- @@License:
    This file is part of FarCry Google Maps Plugin.

    FarCry Google Maps Plugin is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    FarCry Google Maps Plugin is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with FarCry Google Maps Plugin.  If not, see <http://www.gnu.org/licenses/>.
--->
<cfcomponent extends="farcry.core.packages.types.types" displayName="Google Map Locations" hint="Google map locations that appear on Google Maps" bFriendly="1" bobjectbroker="true" objectbrokermaxobjects="1000">
	
	<!------------------------------------------------------------------------
	type properties
	------------------------------------------------------------------------->	
	<cfproperty ftSeq="11" ftFieldSet="Details" name="Title" bLabel="true" type="string" hint="Title of the location" required="true" ftLabel="Title" ftType="string" />
	<cfproperty ftSeq="12" ftFieldSet="Details" name="Teaser" type="longchar" hint="Description of the location" required="false" ftLabel="Location Description" ftType="richtext" />
	
	<!--- Icons --->
<!---	Want to use this for cleanliness, but doesn't allow for reuse of previously uploaded images
<cfproperty ftSeq="21" ftFieldset="Image Files" name="Icon" type="string" hint="The URL location of the location icon" required="no" default="" ftType="Image" ftDestination="/images/googleMapLocation/icons" ftImageWidth="25" ftImageHeight="25" ftAutoGenerateType="Pad" ftPadColor="##ffffff" ftlabel="Location Icon" />
--->
	<cfproperty ftSeq="21" ftFieldset="Image Files" name="Icon" type="UUID" hint="The UUID of the location icon from dmImage" required="no" default="" ftType="UUID" ftJoin="dmImage">
	
	<!--- GEOCODING --->
	<cfproperty ftSeq="31" ftFieldSet="Geocoding" name="Geocode" type="longchar" hint="An actual address to use geocoding to render the map" required="false" ftLabel="Physical address" ftType="longchar" />
	
	<!--- LONG/LAT --->
	<cfproperty ftSeq="41" ftFieldSet="Latitude and Longitude" name="LatLong" type="string" hint="Latitude and longitude of the map location" required="false" ftLabel="Latitude and Longitude" ftType="latLong" />

	<!------------------------------------------------------------------------
	object methods 
	------------------------------------------------------------------------->	

<!--- For use with the image upload property
	<cffunction name="getIconDetail" access="public" displayname="Get Icon Details for Map Location" hint="returns a structure containing url, height and width for an associated icon image" returntype="struct" output="false">
		<cfargument name="ObjectID" type="UUID" required="true">
		
		<cfset var stLocation = getData(ObjectID) />
		<cfset var stIconDetail = structNew() />
		<cfset stIconDetail.IconURL = stLocation.icon />
		<cfset stIconDetail.height = application.types.googleMapLocation.stProps.icon.metadata.ftImageHeight />
		<cfset stIconDetail.width = application.types.googleMapLocation.stProps.Icon.metadata.ftImageWidth / >
	
	<cfreturn stIconDetail />
	</cffunction>
--->

<!--- Get Image details for a library image --->
	<cffunction name="getIconDetail" access="public" displayname="Get Icon Details for Map Location" hint="returns a structure containing url, height and width for an associated icon image" returntype="struct" output="false">
		<cfargument name="ObjectID" type="UUID" required="true">
		
		<cfset var stIconDetail = structNew() />

		<!--- set up image objects --->
		<cfset var oImage = createObject("component",application.types["dmImage"].packagepath) />
		<cfset var oImageUtils = createObject("component",application.packagepath&".farcry.imageUtilities") />
		<!--- get the location data --->
		<cfset var stLocation = getData(ObjectID) />
		
		<cfset stIconDetail = oImageUtils.fGetProperties(expandPath(oImage.getURLImagePath(stLocation.icon,"original"))) />
		<cfset stIconDetail.IconURL = oImage.getURLImagePath(stLocation.icon,"original") />
	
	<cfreturn stIconDetail />
	</cffunction>
		
</cfcomponent>