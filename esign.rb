require 'byebug'
require 'httparty'
require 'json'

headers = {
   'Content-Type' => 'application/json',
   'Authorization' => "Basic UXczSDlGMVRpNEkzOnhjRTFjUHVYS3g0Qw=="
  }

test_doc_template_id = "jyFMK9oBjZSOKTi2NcTPvmDNyLs="

create_package = HTTParty.post(
  "https://sandbox.esignlive.com/api/packages/#{test_doc_template_id}/clone",
  body: {
    name: "TEST_PACKAGE_ONE",
    type: "PACKAGE",
    language: "en",
    emailMessage: "bla bla bla",
    description: "New Package",
    autoComplete:true,
    settings: {
      ceremony: {
        inPerson: false
      }
    },
    visibility: "ACCOUNT"
  }.to_json,
  headers: headers
)

package_id = create_package.parsed_response["id"]

auth_request_package = HTTParty.post(
  "https://sandbox.esignlive.com/api/authenticationTokens",
  body: {
    packageId: package_id,
  }.to_json,
  headers: headers
)

package = HTTParty.get(
  "https://sandbox.esignlive.com/api/packages/#{package_id}",
  headers: headers
)

package_roles = HTTParty.get(
  "https://sandbox.esignlive.com/api/packages/#{package_id}/roles",
  headers: headers
)

debugger


puts "..."

