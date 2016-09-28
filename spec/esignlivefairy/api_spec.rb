require 'esignlivefairy/api'

module EsignliveFairy
  RSpec.describe API do
    let(:api_key) { SecureRandom.uuid }
    let(:api_instance) { described_class.new(api_key: api_key) }

    describe '#initialize' do
      let(:expected_headers) do
        {
          'Content-Type' => 'application/json',
          'Authorization' => "Basic #{api_key}"
        }
      end
      it 'sets the headers' do
        expect(api_instance.headers).to eq expected_headers
      end
    end

    describe 'API calls' do
      let(:real_api_key) { "djI2T0dXdDBoMGNCOjJ3dnVUS1V6U0FjUw=="}
      describe 'Packages' do
        describe '#get_packages' do
          it 'returns packages' do
            api_instance = described_class.new(api_key: real_api_key)
            result = api_instance.get_packages
            count = result.parsed_response["count"]
            expect(count).to eq 0
          end
        end
        describe '#get_package(package_id:)' do
          it 'returns a package'
        end
      end

      describe '#create_package_from_template(template_id:, opts: opts={})' do
        it 'creates a package and returns its id' do
          real_template_id = "2LVibGavwD95en0NWbgYSXh4-vg="
          api_instance = described_class.new(api_key: real_api_key)
          result = api_instance.create_package_from_template(template_id: real_template_id)
          expect(result.parsed_response["id"]).to be_a String
        end
      end
    end

  end
end