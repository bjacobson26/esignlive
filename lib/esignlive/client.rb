require 'esignlive/api/calls'

module ESignLive
  class Client
    include ESignLive::API::Calls

    attr_reader :headers

    def initialize(api_key:)
      @headers = create_headers(api_key)
    end

    private

    def create_headers(api_key)
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Basic #{api_key}"
      }
    end
  end
end
