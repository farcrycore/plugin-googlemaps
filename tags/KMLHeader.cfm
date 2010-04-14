<cfsetting enablecfoutputonly="yes">

<!--- KML Reference
	2.1 http://code.google.com/apis/kml/documentation/kml_tags_21.html
	2.2 BETA http://code.google.com/apis/kml/documentation/kml_tags_beta1.html	
--->

<cfif thistag.executionMode eq "start">
	<cfparam name="attributes.KMLVersion" default="2.2" />
	<cfparam name="attributes.objectid" default="" />
	<cfparam name="attributes.title" default="" />
	<cfparam name="attributes.open" default="1" />
	<cfparam name="attributes.teaser" default="" />
	
	<cfoutput><?xml version="1.0" encoding="UTF-8"?>
	</cfoutput>
	
	<cfoutput><kml xmlns="http://earth.google.com/kml/#attributes.KMLVersion#">
	<Document<cfif len(trim(attributes.objectid))> id="#trim(attributes.objectid)#"</cfif>>
		<name>#XMLFormat(attributes.title)#</name>
		<open>#attributes.open#</open>
	</cfoutput>

	<cfif len(trim(attributes.teaser))>
		<cfoutput>	<description><![CDATA[#attributes.stParam.teaser#]]></description></cfoutput>
	</cfif>

</cfif>

<cfif thistag.executionMode eq "end">
	<cfexit method="EXITTAG" />
</cfif>

<cfsetting enablecfoutputonly="no">