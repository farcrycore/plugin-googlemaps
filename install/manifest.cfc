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
<cfcomponent extends="farcry.core.webtop.install.manifest" name="manifest">

	
	<cfset this.name = "googlemaps" />
	<cfset this.description = "farcry Google Maps plugin" />
	<cfset this.lRequiredPlugins = "" />
	<cfset addSupportedCore(majorVersion="4", minorVersion="0", patchVersion="0") />
	<cfset addSupportedCore(majorVersion="5", minorVersion="0", patchVersion="0") />
	

	

</cfcomponent>

