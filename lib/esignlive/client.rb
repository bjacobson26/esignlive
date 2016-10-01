require 'esignlive/api/calls'

module ESignLive
  class Client
    include ESignLive::API::Calls

    attr_reader :headers, :environment

    VALID_ENVIRONMENTS = %w(sandbox production)


    def initialize(api_key:, environment: "sandbox")
      check_environment(environment)
      @headers = create_headers(api_key)
      @environment = environment
    end

    def url
      if environment == "sandbox"
        "https://sandbox.esignlive.com/api"
      elsif environment == "production"
        "https://apps.esignlive.com/api"
      else
      end
    end

    private

    def create_headers(api_key)
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Basic #{api_key}"
      }
    end

    def check_environment(env)
      unless VALID_ENVIRONMENTS.include?(env)
        raise EnvironmentError.new("environment must be set to 'sandbox' or 'production'")
      end
    end

    class EnvironmentError < StandardError ; end
  end
end
