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