Web Services for Tcl (aka tclws)
================================


###Synopsis
The distribution provides both client side access to Web Services and server side creation of Web Services. 
Currently only document/literal and rpc/encoded with HTTP Soap transport are supported on the client side. 
The server side currently works only with TclHttpd or embedded into an application. 
The server side provides all services as document/literal over HTTP Soap transport.

#### SOAP Client
```tcl
package require WS::Client

# Use enviromental proxy settings if available
package require autoproxy
::autoproxy::init

# Grok the service, and generate stubs
::WS::Client::GetAndParseWsdl "http://www.webservicex.net/geoipservice.asmx?wsdl"

# Initialize and create stubs for the service
::WS::Client::CreateStubs GeoIPService

# Returns 2 functions available
#   ::GeoIPService::GetGeoIP IPAddress
#   ::GeoIPService::GetGeoIPContext {}

# Call the function of the service
::set result [::GeoIPService::GetGeoIP xx.xxx.xx.xx]

puts $result
# Returns a dictionary result
#   GetGeoIPResult {ReturnCode 1 IP xx.xxx.xx.xx ReturnCodeDetails Success CountryName {United States} CountryCode USA}

puts [dict get $result GetGeoIPResult CountryName]
# Returns
#   United States
```

More documentations here http://core.tcl.tk/tclws/doc/tip/docs/index.html
