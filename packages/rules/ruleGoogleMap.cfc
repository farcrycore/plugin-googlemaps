<cfcomponent displayname="Google maps rule" extends="farcry.core.packages.rules.rules"
			hint="Allows you to select a map from the library of Google Maps defined for your application.">
	<cfproperty ftSeq="1" ftFieldSet="Maps" name="intro" type="longchar" hint="Introduction HTML for map." ftLabel="Intro" ftType="richtext" />
	<cfproperty ftSeq="2" ftFieldSet="Maps" name="MapID" type="UUID" hint="ID of the map to be displayed" ftLabel="Map" ftType="UUID" ftJoin="googleMap" />
	<cfproperty ftSeq="5" ftFieldset="Maps" name="displayMethod" type="string" hint="Display method to render this map object with." required="yes" default="displayMap" ftLabel="Display Method" ftType="webskin" fttypename="googleMap" ftPrefix="display">

<cffunction name="execute" hint="Displays the text rule on the page." output="false" returntype="void" access="public">
	<cfargument name="objectID" required="Yes" type="uuid" default="">
	<cfset var stObj = getData(arguments.objectid) />
	<cfset var oGMap = createObject("component","farcry.plugins.googleMaps.packages.types.googlemap") />
	<cfset var stData = oGMap.getData(stObj.MapID) /> 
	<cfset var stInvoke = structNew() />
	
	<cfscript>
		if (len(stObj.intro))
			arrayAppend(request.aInvocations,stObj.intro);
		stInvoke.objectID = stData.ObjectID;
		stInvoke.typename = application.types.googleMap.typepath;
		stInvoke.method = stObj.displayMethod;
		arrayAppend(request.aInvocations,stInvoke);
	</cfscript>
</cffunction>
</cfcomponent>