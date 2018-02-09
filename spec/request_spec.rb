require 'spec_helper'

describe ShieldPay::Request do

  it "checks for valid org key" do
    stub_request = stub_post_request("/Customer/CreateCompany",
                                     { "CountryCode" => 'GB' },
                                     "request/invalid_org_key.json")
    expected_error = ShieldPay::Errors::InvalidOrganizationKey
    expect { ShieldPay::Company.create }.to raise_error(expected_error)
  end

end
