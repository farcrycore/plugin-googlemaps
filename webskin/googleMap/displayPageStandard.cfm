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
		
			if (arrayLen(stObj.aLocations))	//there are locations to plot, load the map
			{
				HTML = getView(stObject=stObj,template="displayMap");
				writeOutput(HTML);
			}
		
		</cfscript>

<cfoutput>
	</div>		
</cfoutput>

<!--- footer --->
<cfmodule template="/farcry/#application.applicationname#/webskin/includes/dmFooter.cfm">

<cfsetting enablecfoutputonly="false">