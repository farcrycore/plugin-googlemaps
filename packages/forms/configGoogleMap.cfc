<cfcomponent displayname="Google Map Config" hint="Google Map Config" extends="farcry.core.packages.forms.forms" output="false" key="googleMaps">
	
	<cfproperty ftSeq="1" ftFieldset="" name="apiKey" type="string" default="" hint="Key for Google Map API" ftLabel="Google API Key" ftValidation="required" ftHint="<a href='http://code.google.com/apis/maps/signup.html' target='googleMapAPISignup'>Sign Up for the Google Maps API</a> to get an API for your domain" />

</cfcomponent>