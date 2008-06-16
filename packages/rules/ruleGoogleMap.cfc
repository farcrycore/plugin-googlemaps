<!--- @@Copyright: Daemon Pty Limited 2002-2008, http://www.daemon.com.au --->
<!--- @@License:
    This file is part of FarCry Google Maps Plugin.

    FarCry Google Maps Plugin is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    FarCry Google Maps Plugin is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with FarCry Google Maps Plugin.  If not, see <http://www.gnu.org/licenses/>.
--->
<cfcomponent displayname="Google maps rule" extends="farcry.core.packages.rules.rules"
			hint="Allows you to select a map from the library of Gogle Maps defined for your application.">
	<cfproperty ftSeq="1" ftFieldSet="Maps" name="intro" type="longchar" hint="Introduction HTML for map." ftLabel="Intro" ftType="longchar" />
	<cfproperty ftSeq="2" ftFieldSet="Maps" name="MapID" type="UUID" hint="ID of the map to be displayed" ftLabel="Map" ftType="UUID" ftJoin="googleMap" />
	
<cffunction name="execute" hint="Displays the text rule on the page." output="true" returntype="void" access="public">
	<cfargument name="objectID" required="Yes" type="uuid" default="">
	<cfset var stObj = getData(arguments.objectid) />
	<cfset var oGMap = createObject("component","farcry.plugins.googlemaps.packages.types.googlemap") />
	<cfset var stData = oGMap.getData(stObj.MapID) /> 
	<cfset var stInvoke = structNew() />
	
	<cfscript>
		if (len(stobj.intro))
			arrayAppend(request.aInvocations,stobj.intro);
		stInvoke.objectID = stData.ObjectID;
		stInvoke.typename = application.types.googleMap.typepath;
		stInvoke.method = 'displayMap';
		arrayAppend(request.aInvocations,stInvoke);
	</cfscript>
</cffunction>
</cfcomponent>