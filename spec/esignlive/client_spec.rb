require 'esignlive/client'

module ESignLive
  RSpec.describe Client do
    let(:client) { described_class.new(api_key: api_key) }
    let(:api_key) { "test_api_key"}
    let(:expected_headers) do
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Basic #{api_key}"
      }
    end

    describe '#initialize' do
      it 'sets the headers' do
        expect(client.headers).to eq expected_headers
      end

      it 'sets the environment' do
        expect(client.environment).to eq "sandbox"
      end
    end

    describe '#url' do
      context 'sandbox' do
        it 'returns the correct url' do
          client = described_class.new(api_key: api_key, environment: "sandbox")

          expect(client.url).to eq "https://sandbox.esignlive.com/api"
        end
      end
      context 'production' do
        it 'returns the correct url' do
          client = described_class.new(api_key: api_key, environment: "production")

          expect(client.url).to eq "https://apps.esignlive.com/api"
        end
      end
      context 'given an incorrect environment' do
        it 'raises an error message' do

          expect{described_class.new(api_key: api_key, environment: "foobar")}
            .to raise_error ESignLive::Client::EnvironmentError
        end
      end
    end

    describe 'API calls' do
      let(:http_response) { instance_double(HTTParty::Response) }

      before do
        allow(http_response).to receive(:parsed_response)
          .and_return({ results: [] })
      end

      describe '#authentication_token' do
        let(:expected_url) { "https://sandbox.esignlive.com/api/authenticationTokens" }
        let(:expected_body) { { packageId: "123" }.to_json }
        it 'POST authenticationTokens' do
          expect(HTTParty).to receive(:post)
            .with(expected_url, body: expected_body, headers: expected_headers)
              .and_return(http_response)

          client.authentication_token(package_id: "123")
        end
      end

      describe '#sender_authentication_token' do
        let(:expected_url) do
          "https://sandbox.esignlive.com/api/senderAuthenticationTokens"
        end
        let(:expected_body) { { packageId: "123" }.to_json }
        it 'POST senderAuthenticationTokens' do
          expect(HTTParty).to receive(:post)
            .with(expected_url, body: expected_body, headers: expected_headers)
              .and_return(http_response)

          client.sender_authentication_token(package_id: "123")
        end
      end

      describe '#signer_authentication_token' do
        let(:expected_url) do
          "https://sandbox.esignlive.com/api/signerAuthenticationTokens"
        end
        let(:expected_body) { { signerId: "321", packageId: "123" }.to_json }
        it 'POST /signerAuthenticationTokens' do
          expect(HTTParty).to receive(:post)
            .with(expected_url, body: expected_body, headers: expected_headers)
              .and_return(http_response)

          client.signer_authentication_token(package_id: "123", signer_id: "321")
        end
      end

      describe '#get_packages' do
        let(:expected_url) { 'https://sandbox.esignlive.com/api/packages' }
        it "GET /packages" do
          expect(HTTParty).to receive(:get)
            .with(expected_url, headers: expected_headers)
              .and_return(http_response)

          client.get_packages
        end
      end

      describe '#get_package' do
        let(:expected_url) { 'https://sandbox.esignlive.com/api/packages/123' }
        it 'GET /packages/:package_id' do
          expect(HTTParty).to receive(:get)
            .with(expected_url, headers: expected_headers)
              .and_return(http_response)

          client.get_package(package_id: "123")
        end
      end

      describe '#get_signing_status' do
        let(:expected_url) do
          'https://sandbox.esignlive.com/api/packages/123/signingStatus'
        end
        it 'GET packages/:package_id/signingStatus' do
          expect(HTTParty).to receive(:get)
            .with(expected_url, headers: expected_headers)
              .and_return(http_response)

          client.get_signing_status(package_id: "123")
        end
      end

      describe '#get_document' do
        let(:expected_url) do
          'https://sandbox.esignlive.com/api/packages/1/documents/5'
        end
        context 'pdf = false' do
          it 'GET packages/:package_id/documents/:document_id' do
            expect(HTTParty).to receive(:get)
              .with(expected_url, headers: expected_headers)
                .and_return(http_response)

            client.get_document(package_id: "1", document_id: "5")
          end
        end
        context 'pdf = true' do
          it 'GET packages/:package_id/documents/:document_id/pdf' do
            expect(HTTParty).to receive(:get)
              .with("#{expected_url}/pdf", headers: expected_headers)
                .and_return(http_response)

            client.get_document(package_id: "1", document_id: "5", pdf: true)
          end
        end
      end

      describe '#get_roles' do
        let(:expected_url) do
          'https://sandbox.esignlive.com/api/packages/123/roles'
        end
        it 'GET /packages/:package_id/roles' do
          expect(HTTParty).to receive(:get)
            .with(expected_url, headers: expected_headers)
              .and_return(http_response)

          client.get_roles(package_id: "123")
        end
      end

      describe '#get_role' do
        let(:expected_url) do
          'https://sandbox.esignlive.com/api/packages/123/roles/3'
        end
        it 'GET /packages/:package_id/roles/:role_id' do
          expect(HTTParty).to receive(:get)
            .with(expected_url, headers: expected_headers)
              .and_return(http_response)

          client.get_role(package_id: "123", role_id: "3")
        end
      end

      describe '#update_role_signer' do
        let(:expected_url) do
          'https://sandbox.esignlive.com/api/packages/1/roles/2'
        end
        let(:expected_body) do
          {
            signers: [
              {
                email: "Bob@test.com",
                firstName: "Bob",
                lastName: "Test"
              }
            ]
          }.to_json
        end
        it 'PUT /packages/:package_id/roles/:role_id' do
          expect(HTTParty).to receive(:put)
            .with(expected_url, body: expected_body, headers: expected_headers)
              .and_return(http_response)

          client.update_role_signer(
            package_id: "1",
            role_id: "2",
            email: "Bob@test.com",
            first_name: "Bob",
            last_name: "Test"
          )
        end
      end

      describe '#create_package' do
        let(:expected_url) { 'https://sandbox.esignlive.com/api/packages' }
        it 'POST /packages' do
          expect(HTTParty).to receive(:post)
            .with(expected_url, body: anything(), headers: expected_headers)
              .and_return(http_response)

          client.create_package
        end
      end

      describe '#create_package_from_template' do
        let(:expected_url) do
          'https://sandbox.esignlive.com/api/packages/215a/clone'
        end
        it 'POST /packages/:template_id/clone' do
          expect(HTTParty).to receive(:post)
            .with(expected_url, body: anything(), headers: expected_headers)
              .and_return(http_response)

          client.create_package_from_template(template_id: "215a")
        end
      end

      describe '#send_package' do
        let(:expected_url) do
          'https://sandbox.esignlive.com/api/packages/12345a'
        end
        let(:expected_body) { { status: "SENT" }.to_json }
        it 'POST /packages/:package_id' do
          expect(HTTParty).to receive(:post)
            .with(expected_url, body: expected_body, headers: expected_headers)
              .and_return(http_response)

          client.send_package(package_id: "12345a")
        end
      end

      describe '#remove_document_from_package' do
        let(:expected_url) do
          'https://sandbox.esignlive.com/api/packages/123a/documents/1c'
        end
        it 'DELETE /packages/:package_id/documents/:document_id' do
          expect(HTTParty).to receive(:delete)
            .with(expected_url, headers: expected_headers)
              .and_return(http_response)

          client.remove_document_from_package(document_id: "1c", package_id: "123a")
        end
      end

      describe 'signing_url' do
        let(:expected_url) do
          'https://sandbox.esignlive.com/api/packages/1a/roles/2b/signingUrl'
        end
        it 'GET /packages/:package_id/roles/:role_id/signingUrl' do
          expect(HTTParty).to receive(:get)
            .with(expected_url, headers: expected_headers)
              .and_return(http_response)

          client.signing_url(package_id: "1a", role_id: "2b")
        end
      end

    end
  end
end
