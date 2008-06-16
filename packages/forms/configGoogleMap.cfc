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
<cfcomponent displayname="Google Map Config" hint="Google Map Config" extends="farcry.core.packages.forms.forms" output="false" key="googleMaps">
	
	<cfproperty ftSeq="1" ftFieldset="" name="apiKey" type="string" default="" hint="Key for Google Map API" ftLabel="Google API Key" ftValidation="required" ftHint="<a href='http://code.google.com/apis/maps/signup.html' target='googleMapAPISignup'>Sign Up for the Google Maps API</a> to get an API for your domain" />

</cfcomponent>