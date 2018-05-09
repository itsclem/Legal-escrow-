require 'httparty'
require 'json'

module ShieldPay

  class Request

    include HTTParty
    include Errors

    UPPERCASE_KEYS = ["iban"]

    def post(path, params)
      url = ShieldPay.configuration.endpoint_url + path
      params = add_auth_key(params)
      attrs = {
        body: processed_params(params),
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

    def processed_keys(keys)
      keys.inject({}) do |result, (key, value)|
        if UPPERCASE_KEYS.include?(key)
          result[key.upcase] = value
        else
          result[underscore_to_camel_case(key)] = value
        end
        result
      end
    end

    def processed_params(params)
      params = processed_keys(params)
      # set the values to strings
      params.inject({}) do |result, (key, value)|
        result[key] = value.to_s
        result
      end.to_json
    end

    def underscore_to_camel_case(string)
      string.to_s.split('_').collect(&:capitalize).join
    end

  end
end
