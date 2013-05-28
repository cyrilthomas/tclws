tclws
=====

TCL Core mirror - Web Services for Tcl (aka tclws)
###Synopsis

```tcl
package require WS::Client

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
