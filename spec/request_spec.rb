require 'spec_helper'

describe ShieldPay::Request do

  it "checks for valid org key" do
    stub_request = stub_post_request("/Customer/CreateCompany",
                                     { "CountryCode" => 'GB' },
                                     "request/invalid_org_key.json")
    expected_error = ShieldPay::Errors::InvalidOrganizationKey
    expect { ShieldPay::Company.create }.to raise_error(expected_error)
  end

  it 'camel cases the keys' do
    stub_request = stub_post_request("/Customer/CreateCompany",
                                     { "CountryCode" => 'NZ' },
                                     "company/created_successfully.json")
    ShieldPay::Company.create(country_code: "NZ")
    assert_requested(stub_request)
  end

  it "certain keys aren't in camel case" do
    stub_request = stub_post_request("/BankDetail/AddBankDetail",
                                     { "IBAN" => '555555' },
                                     "company/created_successfully.json")
    ShieldPay::BankDetail.update(iban: "555555")
    assert_requested(stub_request)
  end

end
