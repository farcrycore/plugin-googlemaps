<cfsetting enablecfoutputonly="yes">

<!--- @@displayname: Export Map to KML --->

<!--- List of GoogleMap objectids to export --->
<cfparam name="URL.MapIDs" default="" />
<cfparam name="URL.xmlFile" default="googleMaps" />
<cfparam name="URL.compress" default="1" />
<cfparam name="URL.debug" default="0" />
<cfparam name="URL.title" default="" />

<!--- <cfdump var="#URL#" /> --->

<!--- Validate args --->

<cfimport taglib="/farcry/core/tags/admin/" prefix="admin">
<cfimport taglib="/farcry/plugins/googleMaps/tags/" prefix="gm">

<admin:header title="Export to KML">

<cfoutput><h1>Export to KML</h1></cfoutput>

<cfif NOT len(trim(URL.MapIDs))>

	<cfoutput><p class="error">No MapIDs supplied</p></cfoutput>
	
<cfelse>

	<gm:KMLFile lMapIDs="#URL.MapIDs#" name="#URL.title#" r_KML="sKML" />
	
 	<cfif isBoolean(URL.debug) AND URL.debug>
		<cfoutput>
		<h2></h2>
		<form>
			<textarea cols="120" rows="30">#sKML#</textarea>
		</form>
		</cfoutput>
	</cfif>
	
	<!--- check directory exists --->
	<cfset sFullExportPath = "#Application.path.project#/#Application.config.general.exportPath#" />
	<!--- <cfset sFullExportURL = "http://#CGI.http_host#/#Application.config.general.exportPath#" /> --->
 	<cfif NOT directoryExists(sFullExportPath)>
		<cfdirectory action="CREATE" directory="sFullExportPath">
		<p class="highlight">Created Folder #sFullExportPath#</p>
	</cfif>
	
	<cfoutput><h2>Attempting to create KML file</h2></cfoutput>
 	<cftry>
		<!--- generate file --->
		<cfset sKMLFile = "#sFullExportPath#/#URL.xmlFile#.kml" />
		<cffile action="write" file="#sKMLFile#" output="#sKML#" addnewline="no" nameconflict="OVERWRITE">

		<cfoutput>
			<p>KML file written to #sKMLFile#<p>
			<!--- <p class="success">Created <a href="#sFullExportURL#/#URL.xmlFile#.kml">#sFullExportURL#/#URL.xmlFile#.kml</a></p> --->
		</cfoutput>
		
		<cfcatch>
			<cfoutput><span class="error">#cfcatch.message#</span></p></cfoutput>
			<cfdump var="#cfcatch#" expand="false" />
		</cfcatch>
		
	</cftry>
	<!--- ZIP KML file to create KMZ --->
 	<cfif URL.compress>
		<!--- This will create a web-dependant KMZ i.e. it will use links to icons rather than package the icons in te KMZ (see http://earth.google.com/outreach/tutorial_kmz.html#webdependent) --->
		<cfoutput><h2>Attempting to create KMZ file</h2></cfoutput>
		<cftry>
			<!--- createZip --->
			<cfscript>
				sKMZFile = "#sFullExportPath#/#URL.xmlFile#.kmz";
				oZip = createObject("component", "#Application.packagepath#.farcry.zip");
				oZip.createZip(srcFileNames=sKMLFile,destZipName=sKMZFile);
			</cfscript>
			
			<cfoutput>
				<p>KMZ file written to #sKMZFile#</p>
				<!--- <p class="success">Created <a href="#sFullExportURL#/#URL.xmlFile#.kmz">#sFullExportURL#/#URL.xmlFile#.kmz</a></p> --->
			</cfoutput>
			
			<cfcatch>
				<cfoutput><span class="error">#cfcatch.message#</span></p></cfoutput>
				<cfdump var="#cfcatch#" expand="false" />
			</cfcatch>
			
		</cftry>
	</cfif>
	
	<cfoutput><h2 class="success">All done.</h2></cfoutput>
	
</cfif>

<cfoutput>
<hr />
<h2>Usage Arguments</h2>
<dl>
	<dt>MapIDs [REQUIRED]</dt>
	<dd>ObjectID of the Google Map(s) to export (you can supply a comma-delimited list of Map ObjectIDs)</dd>
	<dt>xmlFile</dt>
	<dd>Name for KML file [default: googleMaps] (Note: .kml extension is automatically added)</dd>
	<dt>compress</dt>
	<dd>Boolean to compress KML file (creates KMZ file) [default: true]</dd>
	<dt>debug</dt>
	<dd>View created KML [default: false]</dd>
</dl>
</cfoutput>
	
<admin:footer>

<cfsetting enablecfoutputonly="no">