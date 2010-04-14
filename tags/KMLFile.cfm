<cfsetting enablecfoutputonly="yes" />

<cfif thistag.executionMode eq "start">
	<cfparam name="attributes.lMapIDs" default="" />
	<cfparam name="attributes.name" default="" />
	<cfparam name="attributes.id" default="" />
	<cfparam name="attributes.open" default="1" />
	<cfparam name="attributes.r_KML" default="" />
	
	<cfimport taglib="/farcry/plugins/googleMaps/tags/" prefix="gm">
		
	<!--- create the map object which will give us all plot points --->
	<cfset oMap = createObject("component", application.types["googleMap"].packagepath) />
	<cfset oMapLocation = createObject("component", application.types["googleMapLocation"].packagepath) /> 

	<!--- KML Reference http://code.google.com/apis/kml/documentation/kml_tags_21.html --->
	
	<cfsavecontent variable="sKML">
		<gm:KMLHeader objectid="#attributes.id#" title="#attributes.name#" open="#attributes.open#" />
		
		<!--- loop for each map --->
		<cfloop list="#attributes.lMapIDs#" index="map">
			<!--- get map --->
			<cfset stMap = oMap.getData(objectid=map) />
			<!--- TODO 20080117 whiterd | only use folders if more than one map objectid is supplied --->
			<gm:KMLFolder stParam="#stMap#">
			
			<cfloop from="1" to="#arrayLen(stMap.aLocations)#" index="loc">
				<cfset stLocation = oMapLocation.getData(objectid=stMap.aLocations[loc]) />
				<gm:KMLPlacemark stParam=#stLocation# />
			</cfloop>
			
			</gm:KMLFolder>
		</cfloop>
		
		<gm:KMLFooter />
	</cfsavecontent>
	
	<!--- having lots of whitespace issue in CF7 (but not in CF 8). Use a brute force approach to remove whitespace in the KML file --->
<!--- 	<cfset sKML = REReplaceNoCase(sKML, "[[:space:]]{2,}[#Chr(13)##Chr(10)#]{2,}", "", "ALL") />
	<cfset sKML = trim(sKML) /> --->
	
	<cfif len(trim(attributes.r_KML))>
		<cfset caller[attributes.r_KML] = sKML />
	<cfelse>
		<cfoutput>#sKML#</cfoutput>
	</cfif>
	
</cfif>

<cfif thistag.executionMode eq "end">
	<cfexit method="EXITTAG" />
</cfif>

<cfsetting enablecfoutputonly="no" />