<cfsetting enablecfoutputonly="yes" />
<!-- take a googleMaps objectid and stream a KML (KMZ) file --->

<cfparam name="URL.objectid" default="DD8DE6DC-D60D-D1D4-C631238D4AA611DE" />
<cfparam name="URL.format" default="kml" /><!--- TODO 20080117 whiterd | Future possibility of GML (Geographic Markup) format --->
<cfparam name="URL.compress" default="true" /><!--- TODO 20080117 whiterd | Compress stream to serve a KMZ (KML+ZIP compression) --->

<cfimport taglib="/farcry/plugins/googleMaps/tags/" prefix="gm">

<cfinclude template="/farcry/plugins/googleMaps/tags/gmFunctions.cfm" />

<!--- create the map object which will give us all plot points --->
<cfset oMap = createObject("component", application.types["googleMap"].packagepath) />

<cfset stMap = oMap.getData(objectid=URL.objectid) />

<cfif NOT len(trim(URL.objectid)) OR NOT IsCFUUID(URL.objectid)>

	<cfoutput><p class="error">No Map objectid supplied</p></cfoutput>
	
<cfelse>
	
	<cftry>
		<gm:KMLFile lMapIDs="#URL.objectid#" name="#stMap.title#" r_KML="sKML" />
		<cfcatch>
			<cfdump var="#cfcatch#">
		</cfcatch>
	</cftry>
	
	<!--- MIME types - KML:application/vnd.google-earth.kml+xml, KMZ:application/vnd.google-earth.kmz --->
 	<cfcontent type="application/vnd.google-earth.kml+xml" reset="true" />
	<cfheader name="content-disposition" value="attachment;filename=#filterFilename(stMap.title)#.kml">
	<cfoutput>#sKML#</cfoutput>

</cfif>

<cfsetting enablecfoutputonly="no" />