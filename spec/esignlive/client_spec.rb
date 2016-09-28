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
    end
  end
end
