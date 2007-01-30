<cfsetting enablecfoutputonly="true">

<cfimport taglib="/farcry/farcry_core/tags/formtools" prefix="tags">

<tags:objectAdmin 
	title="Google Maps" 
	typename="GoogleMap" 
	ColumnList="label"
	SortableColumns="label"
	lFilterFields="label"
	sqlorderby="datetimelastUpdated desc"
	libraryName="googlemaps"
 />

<cfsetting enablecfoutputonly="false">