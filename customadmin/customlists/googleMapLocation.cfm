<cfsetting enablecfoutputonly="true">

<cfimport taglib="/farcry/core/tags/formtools" prefix="tags">

<tags:objectAdmin 
	title="Google Map Location" 
	typename="googleMapLocation" 
	ColumnList="label"
	SortableColumns="label"
	lFilterFields="label"
	plugin="googlemaps"
	sqlorderby="datetimelastUpdated desc" />

<cfsetting enablecfoutputonly="false">