<cfsetting enablecfoutputonly="true">

<cfimport taglib="/farcry/farcry_core/tags/formtools" prefix="tags">

<tags:objectAdmin 
	title="Google Map Location" 
	typename="googleMapLocation" 
	ColumnList="label"
	SortableColumns="label"
	lFilterFields="label"
	libraryname="googlemaps"
	sqlorderby="datetimelastUpdated desc" />

<cfsetting enablecfoutputonly="false">