<cfsetting enablecfoutputonly="yes" />

<cffunction name="resolveURL" output="false" returntype="string" hint="Takes text with img and a tags and makes relative URLs absolute (ignores already absolute URLs)">
	<cfargument name="sString" type="string" required="true" />
	<cfargument name="sHostString" type="string" default="#cgi.HTTP_HOST#" required="false" />
	<!--- <cfargument name="sHostString" type="string" default="#cgi.HTTP_HOST#" required="false" />
	SERVER_PORT_SECURE SERVER_PORT SERVER_PROTOCOL=HTTP/1.1--->
	<!---
	<a href="http://www.janegoodall.org/Gombe-Chimp-Blog/feeds/Archives.kml">Blog Archives </a>
	<img border="0" height="257" src="http://www.janegoodall.org/Gombe-Chimp-Blog/IMAGES/Old-Images/Faustino-1.jpg" width="350"/>
	--->
	<cfset var sResult = "" />
	<cfset sResult = replace(Trim(sString)," ","","all") />
	<cfreturn sResult />
</cffunction>

<!--- TODO 20080115 whiterd | isUUID function --->

<!---
 This function will remove any reserved characters from a filename string and replace any spaces with underscores.
 
 @param filename 	 Filename. (Required)
 @return Returns a string. 
 @author Jason Sheedy (jason@jmpj.net) 
 @version 1, January 19, 2006 
--->
<cffunction name="filterFilename" access="public" returntype="string" output="false" hint="I remove any special characters from a filename and replace any spaces with underscores.">
	<cfargument name="filename" type="string" required="true" />
	<cfset var filenameRE = "[" & "'" & '"' & "##" & "/\\%&`@~!,:;=<>\+\*\?\[\]\^\$\(\)\{\}\|]" />
	<cfset var newfilename = reReplace(arguments.filename,filenameRE,"","all") />
	<cfset newfilename = replace(newfilename," ","_","all") />
	
	<cfreturn newfilename /> 
</cffunction>

<cfscript>
/**
 * Returns TRUE if the string is a valid CF UUID.
 * 
 * @param str 	 String to be checked. (Required)
 * @return Returns a boolean. 
 * @author Jason Ellison (jgedev@hotmail.com) 
 * @version 1, November 24, 2003 
 */
function IsCFUUID(str) {  	
	return REFindNoCase("^[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{16}$", str);
}
</cfscript>


<cfsetting enablecfoutputonly="no" />