<!--- 
    Name			: displayPageStandard.cfm
    Author			: Matthew Bryant, Michael Sharman
    Created			: January 26, 2007
	Last Updated	: February 01, 2007
    History			: Initial release (mps 26/01/2007)
    Purpose			: A typical webskin (where you could add containers etc) for google maps displaying the map and title of the page.
					: First check to see if at least one location has been plotted for this map, if so then display map
 --->
<cfsetting enablecfoutputonly="true">


<!--- header --->
<cfmodule template="/farcry/#application.applicationname#/webskin/includes/dmHeader.cfm"
	layoutClass="type-a"
	pageTitle="#stObj.title#">


<cfoutput>	
	<div id="content">
	
		<h1>#stObj.title#</h1>
</cfoutput>
		
	<cfscript>
	
		if (arrayLen(stObj.aLocations))	//there are locations to plot, load the map using the user-defined webskin (displayMap)
		{
			writeOutput(getView(stObject=stObj,template="displayMap"));
		}
	
	</cfscript>

<cfoutput>
	</div>		
</cfoutput>


<!--- footer --->
<cfmodule template="/farcry/#application.applicationname#/webskin/includes/dmFooter.cfm">


<cfsetting enablecfoutputonly="false">