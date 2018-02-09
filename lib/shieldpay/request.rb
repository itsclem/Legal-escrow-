require 'httparty'
require 'json'

module ShieldPay

  class Request

    include HTTParty
    include Errors

    def post(path, params)
      url = ShieldPay.configuration.endpoint_url + path
      params = add_auth_key(params)
      attrs = {
        body: camel_cased_keys(params).to_json,
        headers: headers
      }
      attrs[:debug_output] = $stdout if debug_mode?
      response = HTTParty.post(url, attrs)
      parse_response(response)
    end

    private

    def add_auth_key(params)
      params["organization_key"] = ShieldPay.configuration.org_key
      params
    end

    def camel_cased_keys(params)
      params.inject({}) do |result, (key, value)|
        result[underscore_to_camel_case(key)] = value
        result
      end
    end

    def debug_mode?
      ShieldPay.configuration.debug
    end

    def display_debug(response)
      if debug_mode?
        puts "-" * 20 + " DEBUG " + "-" * 20
        puts response
        puts "-" * 18 + " END DEBUG " + "-" * 18
      end
    end

    def headers
      {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    end

    def parse_response(response)
      as_json = JSON.parse(response.body.to_s)
      check_for_error(as_json)
      display_debug(response.body)
      as_json
    end

    def underscore_to_camel_case(string)
      string.to_s.split('_').collect(&:capitalize).join
    end

  end
end
