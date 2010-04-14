<cfsetting enablecfoutputonly="yes">

<!--- KML Reference
	2.1 http://code.google.com/apis/kml/documentation/kml_tags_21.html
	2.2 BETA http://code.google.com/apis/kml/documentation/kml_tags_beta1.html	
--->

<cfif thistag.executionMode eq "start">
	<cfparam name="attributes.stParam.objectid" default="#createUUID()#" />
	<cfparam name="attributes.stParam.title" default="" />
	<cfparam name="attributes.open" default="1" />
	
	<cfparam name="attributes.stParam" default="#structNew()#" />
	
	<cfoutput>
	<Folder<cfif len(trim(attributes.stParam.objectid))> id="#trim(attributes.stParam.objectid)#"</cfif>>
		<name>#attributes.stParam.title#</name>
		<open>1</open>
	</cfoutput>

</cfif>

<cfif thistag.executionMode eq "end">
	<cfoutput>
		</Folder></cfoutput>
	
</cfif>

<cfsetting enablecfoutputonly="no">