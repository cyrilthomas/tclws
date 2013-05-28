###############################################################################
##                                                                           ##
##  Copyright (c) 2006, Visiprise Software, Inc                              ##
##  All rights reserved.                                                     ##
##                                                                           ##
##  Redistribution and use in source and binary forms, with or without       ##
##  modification, are permitted provided that the following conditions       ##
##  are met:                                                                 ##
##                                                                           ##
##    * Redistributions of source code must retain the above copyright       ##
##      notice, this list of conditions and the following disclaimer.        ##
##    * Redistributions in binary form must reproduce the above              ##
##      copyright notice, this list of conditions and the following          ##
##      disclaimer in the documentation and/or other materials provided      ##
##      with the distribution.                                               ##
##    * Neither the name of the Visiprise Software, Inc nor the names        ##
##      of its contributors may be used to endorse or promote products       ##
##      derived from this software without specific prior written            ##
##      permission.                                                          ##
##                                                                           ##
##  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS      ##
##  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT        ##
##  LIMITED  TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       ##
##  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE           ##
##  COPYRIGHT OWNER OR  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,     ##
##  INCIDENTAL, SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,    ##
##  BUT NOT LIMITED TO,  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;        ##
##  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER         ##
##  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT       ##
##  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR  OTHERWISE) ARISING IN       ##
##  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF  ADVISED OF THE         ##
##  POSSIBILITY OF SUCH DAMAGE.                                              ##
##                                                                           ##
###############################################################################

package require WS::Utils 2.1.3
package require WS::Client 2.1.3

##
## Get Definition of the offered services
##
::WS::Client::GetAndParseWsdl http://localhost:8015/service/wsEchoExample/wsdl

set testString "This is a test"
set inputs [list TestString $testString]

##
## Call synchronously
##
puts stdout "Calling SimpleEcho via DoCalls!"
set results [::WS::Client::DoCall wsEchoExample SimpleEcho $inputs]
puts stdout "\t Received: {$results}"

puts stdout "Calling ComplexEcho via DoCalls!"
set results [::WS::Client::DoCall wsEchoExample ComplexEcho $inputs]
puts stdout "\t Received: {$results}"


##
## Generate stubs and use them for the calls
##
::WS::Client::CreateStubs wsEchoExample
puts stdout "Calling SimpleEcho via Stubs!"
set results [::wsEchoExample::SimpleEcho $testString]
puts stdout "\t Received: {$results}"

puts stdout "Calling ComplexEcho via Stubs!"
set results [::wsEchoExample::ComplexEcho $testString]
puts stdout "\t Received: {$results}"

##
## Call asynchronously
##
proc success {service operation result} {
    global waitVar

    puts stdout "A call to $operation of $service was successful and returned $result"
    set waitVar 1
}

proc hadError {service operation errorCode errorInfo} {
    global waitVar

    puts stdout "A call to $operation of $service was failed with {$errorCode} {$errorInfo}"
    set waitVar 1
}

set waitVar 0
puts stdout "Calling SimpleEcho via DoAsyncCall!"
::WS::Client::DoAsyncCall wsEchoExample SimpleEcho $inputs \
        [list success wsEchoExample SimpleEcho] \
        [list hadError wsEchoExample SimpleEcho]
vwait waitVar

puts stdout "Calling ComplexEcho via DoAsyncCall!"
::WS::Client::DoAsyncCall wsEchoExample ComplexEcho $inputs \
        [list success wsEchoExample SimpleEcho] \
        [list hadError wsEchoExample SimpleEcho]
vwait waitVar

exit