<cfsetting enablecfoutputonly="yes">

<!--- KML Reference
	2.1 http://code.google.com/apis/kml/documentation/kml_tags_21.html
	2.2 BETA http://code.google.com/apis/kml/documentation/kml_tags_beta1.html	
--->

<cfif thistag.executionMode eq "start">
	
<cfoutput>
	</Document>
</kml></cfoutput>
	
</cfif>

<cfif thistag.executionMode eq "end">
	<cfexit method="EXITTAG" />
</cfif>

<cfsetting enablecfoutputonly="no">