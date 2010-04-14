<cfsetting enablecfoutputonly="yes" />

	<cfif len(stObj.intro) >
		<cfoutput>#stObj.intro#</cfoutput>
	</cfif>
	
	<cfif len(stObj.MapID)>
		<cfset  oGMap = createObject("component","farcry.plugins.googleMaps.packages.types.googlemap") />
		<cfset  stData = oGMap.getData(stObj.MapID) /> 
		<cfset  stInvoke = structNew() />
		
		<cfset html = createObject("component", application.stcoapi.googleMap.packagepath).getView(objectid=stData.objectid, template=stObj.displayMethod) />
	
		<cfoutput>#html#</cfoutput>
	</cfif>
	
	<!--- <cfscript>
		if (len(stObj.intro))
			arrayAppend(request.aInvocations,stObj.intro);
		stInvoke.objectID = stData.ObjectID;
		stInvoke.typename = application.types.googleMap.typepath;
		stInvoke.method = 'displayMap';
		arrayAppend(request.aInvocations,stInvoke);
	</cfscript> --->

<cfsetting enablecfoutputonly="no" />
