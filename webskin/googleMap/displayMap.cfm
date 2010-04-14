<cfsetting enablecfoutputonly="true">
<!---
    Name			: displayMap.cfm
    Author			: Michael Sharman, Matthew Bryant
    Created			: January 26, 2007
	Last Updated	: February 01, 2007
    History			: Initial release (mps 26/01/2007)
					: 31/Jan/2007 - removed dependance of JS functions from the <body> tag, added extra map properties
					: 05/Feb/2007 - added numberFormat() to remove possible decimal places on numeric database types
    Purpose			: This display handler is responsible for loading/displaying that actual google map.
					: Should be called from within another webskin, default example is webskin/googleMap/displayPageStandard.cfm
 --->
<!--- @@displayname: Display Map --->


<!--- Import tag libraries --->
<cfimport taglib="../../tags/" prefix="gm">

<gm:displayMap stParam="#stObj#">

<cfsetting enablecfoutputonly="false">