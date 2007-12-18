<cfsetting enablecfoutputonly="yes" />

	<cfif len(stobj.intro) >
		<cfoutput>#stobj.intro#</cfoutput>
	</cfif>
	
	<cfif len(stObj.MapID)>
		<cfset  oGMap = createObject("component","farcry.plugins.googlemaps.packages.types.googlemap") />
		<cfset  stData = oGMap.getData(stObj.MapID) /> 
		<cfset  stInvoke = structNew() />
		
		<cfset html = createObject("component", application.stcoapi.googleMap.packagepath).getView(objectid=stData.objectid, template="displayMap") />
	
		<cfoutput>#html#</cfoutput>
	</cfif>
	
	<!--- <cfscript>
		if (len(stobj.intro))
			arrayAppend(request.aInvocations,stobj.intro);
		stInvoke.objectID = stData.ObjectID;
		stInvoke.typename = application.types.googleMap.typepath;
		stInvoke.method = 'displayMap';
		arrayAppend(request.aInvocations,stInvoke);
	</cfscript> --->

<cfsetting enablecfoutputonly="no" />
