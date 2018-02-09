require 'spec_helper'

describe ShieldPay::Company do
  it 'creates a company' do
    params = {
      "CountryCode" => "GB",
      "Email" => "chris@bananas.com",
      "Identifier" => "00000001",
      "Phone" => "555 12345",
    }

    stub_request = stub_post_request("/Customer/CreateRegisterCustomer",
                                     params,
                                     "create_company.json")

    company = ShieldPay::Company.create(email: "chris@bananas.com",
                                        identifier: "00000001",
                                        phone: "555 12345")

    expect(company.class).to eq(ShieldPay::Company)
    expect(company.country_code).to eq("GB")
    expect(company.email).to eq("chris@bananas.com")
    expect(company.identifier).to eq("00000001")
    expect(company.phone).to eq("555 12345")
    expect(company.customer_key).to eq("ZZZZZZZZZZZ=")
    expect(company.name).to eq("BANANAS LIMITED")
    expect(company.address).to eq("93 Bananas Road")
    expect(company.locality).to eq("London")
    expect(company.post_code).to eq("SW1A 1AA")
    expected_time = Time.parse("2018-02-09T11:03:08.9005669+00:00")
    expect(company.created_on).to eq(expected_time)
  end
end
