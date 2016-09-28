require 'httparty'

module ESignLive
  module API
    module Calls
      URL = "https://sandbox.esignlive.com/api/packages"
      AUTH_URL = "https://sandbox.esignlive.com/api/authenticationTokens"
      SENDER_AUTH_URL = "https://sandbox.esignlive.com/api/senderAuthenticationTokens"
      SIGNER_AUTH_URL = "https://sandbox.esignlive.com/api/signerAuthenticationTokens"
      PACKAGE_DEFAULTS = {
        name: "New Package #{Time.now}",
        language: "en",
        email_message: "Documents to sign!",
        description: "Document(s) require your signature",
        visibility: "ACCOUNT",
        settings: {
          ceremony: {
            inPerson: false
          }
        },
        autocomplete: true
      }

      def authentication_token(package_id:)
        ::HTTParty.post(
          AUTH_URL,
          body: { packageId: package_id }.to_json,
          headers: headers
        ).parsed_response
      end

      def sender_authentication_token(package_id:)
        ::HTTParty.post(
          SENDER_AUTH_URL,
          body: { packageId: package_id }.to_json,
          headers: headers
        ).parsed_response
      end

      def signer_authentication_token(signer_id:, package_id:)
        ::HTTParty.post(
          SIGNER_AUTH_URL,
          body: {
            signerId: signer_id,
            sipackageId: package_id
          }.to_json,
          headers: headers
        ).parsed_response
      end

      def get_packages
        ::HTTParty.get(
          URL,
          headers: headers
        ).parsed_response
      end

      def get_package(package_id:)
        ::HTTParty.get(
          "#{URL}/#{package_id}",
          headers: headers
        ).parsed_response
      end

      def get_signing_status(package_id:)
        ::HTTParty.get(
          "#{URL}/#{package_id}/signingStatus",
          headers: headers
        ).parsed_response
      end

      def get_document(package_id:, document_id:, pdf: false)
        endpoint = "#{URL}/#{package_id}/documents/#{document_id}"
        pdf ? url = "#{endpoint}/pdf" : url = endpoint
        ::HTTParty.get(
          url,
          headers: headers
        ).parsed_response
      end

      def get_roles(package_id:)
        ::HTTParty.get(
          "#{URL}/#{package_id}/roles",
          headers: headers
        ).parsed_response["results"]
      end

      def get_role(package_id:, role_id:)
        ::HTTParty.get(
          "#{URL}/#{package_id}/roles/#{role_id}",
          headers: headers
        ).parsed_response
      end

      def update_role_signer(package_id:, role_id:, email:, first_name:, last_name:)
        body = {
          signers: [
            {
              email: email,
              firstName: first_name,
              lastName: last_name
            }
          ]
        }
        ::HTTParty.put(
         "#{URL}/#{package_id}/roles/#{role_id}",
          body: body.to_json,
          headers: headers
        ).parsed_response
      end

      def create_package(opts: {})
        body = package_hash(opts)
        if opts[:sender].is_a? Hash
          sender_hash = {
            sender: {
              lastName: sender_opts[:last_name],
              firstName: sender_opts[:first_name],
              email: sender_opts[:email]
            }
          }
          body.merge!(sender_hash)
        end
        ::HTTParty.post(
          URL,
          body: body.to_json,
          headers: headers
        ).parsed_response
      end

      def create_package_from_template(template_id:, opts: {})
        ::HTTParty.post(
          "https://sandbox.esignlive.com/api/packages/#{template_id}/clone",
          headers: headers,
          body: package_hash(opts).to_json
        ).parsed_response
      end

      def send_package(package_id:)
        ::HTTParty.post(
          "#{URL}/#{package_id}",
          body: { status: "SENT" }.to_json,
          headers: headers
        )
        true
      end

      def remove_document_from_package(document_id:, package_id:)
        ::HTTParty.delete(
          "#{URL}/#{package_id}/documents/#{document_id}",
          headers: headers
        ).parsed_response
      end

      def signing_url(package_id:, role_id:)
        ::HTTParty.get(
          "#{URL}/#{package_id}/roles/#{role_id}/signingUrl",
          headers: headers
        ).parsed_response["url"]
      end

      def package_hash(opts)
        {
          type: "PACKAGE",
          name:         opts[:name]          || PACKAGE_DEFAULTS[:name],
          language:     opts[:language]      || PACKAGE_DEFAULTS[:language],
          emailMessage: opts[:email_message] || PACKAGE_DEFAULTS[:email_message],
          description:  opts[:description]   || PACKAGE_DEFAULTS[:description],
          autocomplete: opts[:autocomplete]  || PACKAGE_DEFAULTS[:autocomplete],
          settings:     opts[:settings]      || PACKAGE_DEFAULTS[:settings],
          visibility:   opts[:visibility]    || PACKAGE_DEFAULTS[:visibility]
        }
      end
    end
  end
end
