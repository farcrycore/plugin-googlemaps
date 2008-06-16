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
