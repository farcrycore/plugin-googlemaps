<cfsetting enablecfoutputonly="true">

<cfimport taglib="/farcry/core/tags/formtools" prefix="tags">

<tags:objectAdmin 
	title="Google Maps" 
	typename="googleMap" 
	ColumnList="label"
	SortableColumns="label"
	lFilterFields="label"
	libraryname="googlemaps"
	sqlorderby="datetimelastUpdated desc" />

<cfsetting enablecfoutputonly="false">