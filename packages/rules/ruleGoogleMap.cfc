<cfcomponent displayname="Google maps rule" extends="farcry.farcry_core.packages.rules.rules"
			hint="Allows you to select a map from the ">
	<cfproperty ftSeq="1" ftFieldSet="Maps" name="MapID" type="UUID" hint="ID of the map to be displayed" ftLabel="Map" ftType="UUID" ftJoin="googleMap" />

<cffunction name="execute" hint="Displays the text rule on the page." output="true" returntype="void" access="public">
	<cfargument name="objectID" required="Yes" type="uuid" default="">
	<cfset var stObj = getData(arguments.objectid) />
	<cfset var oGMap = createObject("component","farcry.farcry_lib.googlemaps.packages.types.googlemap") />
	<cfset var stData = oGMap.getData(stObj.MapID) /> 
	<cfset var stInvoke = structNew() />
	<cfscript>
		stInvoke.objectID = stData.ObjectID;
		stInvoke.typename = application.types.googleMap.typepath;
		stInvoke.method = 'displayMap';
		arrayAppend(request.aInvocations,stInvoke);
	</cfscript>
</cffunction>
</cfcomponent>