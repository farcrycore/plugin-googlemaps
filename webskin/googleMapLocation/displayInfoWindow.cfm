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
    Name			: displayInfoWindow.cfm
    Author			: Michael Sharman, Matthew Bryant
    Created			: January 31, 2007
	Last Updated	: February 01, 2007
    History			: Initial release (mps 31/01/2007)
    Purpose			: Output to display in the map info window
 --->
<cfsetting enablecfoutputonly="true">

<cfoutput><h3>#stObj.Title#</h3><cfif len(trim(stObj.Teaser))><p>#left(stObj.Teaser, 255)#</p></cfif></cfoutput>

<cfsetting enablecfoutputonly="false">