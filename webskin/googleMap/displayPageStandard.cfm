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
<!--- 
    Name			: displayPageStandard.cfm
    Author			: Matthew Bryant, Michael Sharman
    Created			: January 26, 2007
	Last Updated	: February 01, 2007
    History			: Initial release (mps 26/01/2007)
					: 2/2/2007 MPS: took away coupling to project by removing includes to header/footer files
    Purpose			: This template will really only be used (in its default state) when you preview from Farcry. 
					: Map should either be implemented in a container or a tree type in your project
					: First check to see if at least one location has been plotted for this map, if so then display map
 --->
<cfsetting enablecfoutputonly="true">


<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>farcry: farcry - open source</title>
</head>

<body>

	<div id="content">
	
		<h1>#stObj.title#</h1>
</cfoutput>
		
		
		<cfif arrayLen(stobj.aLocations)>
			<cfset html = getView(stobject="#stobj#", template="displayMap") />
			
			<cfoutput>#html#</cfoutput>
		</cfif>


<cfoutput>
	</div>
	
</body>
</html>
</cfoutput>


<cfsetting enablecfoutputonly="false">