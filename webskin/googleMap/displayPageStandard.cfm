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