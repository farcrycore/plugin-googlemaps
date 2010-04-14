<cfsetting enablecfoutputonly="yes">

<!--- KML Reference
	2.1 http://code.google.com/apis/kml/documentation/kml_tags_21.html
	2.2 BETA http://code.google.com/apis/kml/documentation/kml_tags_beta1.html	
--->

<cfif thistag.executionMode eq "start">
	<cfparam name="attributes.open" default="true" />
	<cfparam name="attributes.maxLines" default="2" />
	<cfparam name="attributes.stParam.objectid" default="#createUUID()#" />
	<cfparam name="attributes.stParam.title" default="" />
	<cfparam name="attributes.stParam.teaser" default="" />
	<cfparam name="attributes.stParam.latLong" default="" /><!--- passed as lat,long list --->
	<cfparam name="attributes.stParam.Geocode" default="" />
	
	<cfparam name="attributes.stParam.icon" default="" />
	<cfparam name="attributes.stParam.iconURL" default="" />
	<cfparam name="attributes.Domain" default="#CGI.http_host#" />
	
	<cfparam name="attributes.stParam" default="#structNew()#" />
	
	<cfoutput>
		<Placemark<cfif len(trim(attributes.stParam.objectid))> id="#attributes.stParam.objectid#"</cfif>>
			<name>#XMLFormat(attributes.stParam.title)#</name>
			<Snippet maxLines="#attributes.maxLines#"></Snippet></cfoutput>
	
	<cfif len(trim(attributes.stParam.teaser))>
		<!--- TODO 20080109 whiterd | need to fully qualify links within teaser text --->
		
		<cfoutput>
			<description><![CDATA[#attributes.stParam.teaser#]]></description></cfoutput>
	</cfif>
	
	<cfif len(trim(attributes.stParam.icon))>
		<cfset oMapLocation = createObject("component", application.types["googleMapLocation"].packagepath) />
		<cfset stIconDetail = oMapLocation.getIconDetail(objectID=attributes.stParam.icon) />
		<cfset attributes.stParam.iconURL = "http://#attributes.Domain##stIconDetail.IconURL#" />
		
	</cfif>
	
	<cfif len(trim(attributes.stParam.iconURL))>
		<cfoutput><Style>
				<IconStyle>
					<Icon><href>#attributes.stParam.iconURL#</href></Icon>
				</IconStyle>
			</Style>
		</cfoutput>
	</cfif>
		
	<cfif len(trim(attributes.stParam.Geocode))><!--- if a <Point> is provided, GoogleEarth takes precedence over the <address> --->
		<cfoutput>
			<address>#attributes.stParam.Geocode#</address></cfoutput>
	</cfif>
	
	<cfif len(trim(attributes.stParam.latLong))>
		<cfoutput>
			<Point>
			</cfoutput>
				<!--- Google Maps likes coords as: lat,long whereas GoogleEarth/KML likes the reverse: long,lat (i.e.<coordinates>long,lat,altitude</coordinates>) --->
				<cfset aCoords = listToArray(trim(attributes.stParam.latLong)) />
				<cfoutput>	<coordinates>#aCoords[2]#,#aCoords[1]#,0</coordinates>
			</Point></cfoutput>
	</cfif>

</cfif>

<cfif thistag.executionMode eq "end">
	<cfoutput>
			</Placemark></cfoutput>
	
</cfif>

<cfsetting enablecfoutputonly="no">