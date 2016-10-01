require 'esignlive/client'

module ESignLive
  RSpec.describe Client do
    let(:api_instance) { described_class.new(api_key: api_key) }
    let(:api_key) { "test_api_key"}

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

      it 'sets the environment' do
        expect(api_instance.environment).to eq "sandbox"
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
  end
end
