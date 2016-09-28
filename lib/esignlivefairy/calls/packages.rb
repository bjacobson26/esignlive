require 'httparty'
require 'byebug'

module EsignliveFairy
  module Calls
    module Packages
      URL = "https://sandbox.esignlive.com/api/packages"

      PACKAGE_DEFAULTS = {
        name: "New Package #{Time.now}",
        language: "en",
        email_message: "Documents to sign!",
        email_description: "Document(s) require your signature",
        visibility: "ACCOUNT",
        settings: {
          ceremony: {
            inPerson: false
          }
        }
      }

      def get_packages
        ::HTTParty.get(
          URL,
          headers: headers
        )
      end

      def get_package(package_id:)
        ::HTTParty.get(
          "#{URL}/#{package_id}",
          headers: headers
        )
      end

      def create_package_from_template(template_id:, opts: opts={})
        ::HTTParty.post(
          "https://sandbox.esignlive.com/api/packages/#{template_id}/clone",
          headers: headers,
          body: {
            type: "PACKAGE",
            name:          opts[:name]         || PACKAGE_DEFAULTS[:name],
            language:      opts[:language]     || PACKAGE_DEFAULTS[:language],
            emailMessage:  opts[:emailMessage] || PACKAGE_DEFAULTS[:email_message],
            description:   opts[:description]  || PACKAGE_DEFAULTS[:email_description],
            autoComplete:  opts[:autocomplete] || PACKAGE_DEFAULTS[:autocomplete],
            settings:      opts[:settings]     || PACKAGE_DEFAULTS[:settings],
            visibility:    opts[:visibility]   || PACKAGE_DEFAULTS[:visibility]
          }.to_json
        )
      end
    end
  end
end