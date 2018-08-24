$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'shieldpay'

require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:all) do
    ShieldPay.configure do |config|
      config.country_code = "GB"
      config.default_currency = "GBP"
      config.org_key = 'test'
      config.uat = true
    end
  end
end

def fixture(filename)
  File.read("#{File.dirname(__FILE__)}/fixtures/#{filename}")
end

def stub_post_request(path, params, json_file)
  params["OrganizationKey"] = ShieldPay.configuration.org_key
  url = ShieldPay.configuration.api_endpoint_url + path

  stub_request(:post, url)
    .with(body: params)
    .to_return(status: 200, body: fixture(json_file))
end
