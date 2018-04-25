require 'spec_helper'

describe ShieldPay::Company do
  it 'creates a company' do
    stubbed_params = {
      "CountryCode" => "GB",
      "Email" => "chris@bananas.com",
      "Identifier" => "00000001",
      "Phone" => "555 12345",
    }

    stub_request = stub_post_request("/Customer/CreateCompany",
                                     stubbed_params,
                                     "company/created_successfully.json")

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
    expect(company.kyc_status).to eq("Verified")
    expected_time = Time.parse("2018-04-25 13:55:12.964171000 +0000")
    expect(company.created_on).to eq(expected_time)
  end

  it "can't create a company that already exists" do
    stubbed_params = {
      "CountryCode" => "GB",
      "Email" => "chris@bananas.com",
      "Identifier" => "00000001",
      "Phone" => "555 12345",
    }

    stub_request = stub_post_request("/Customer/CreateCompany",
                                     stubbed_params,
                                     "company/already_exists.json")

    attrs = {
      email: "chris@bananas.com", identifier: "00000001", phone: "555 12345"
    }
    expected_error = ShieldPay::Errors::CompanyAlreadyExists
    expect { ShieldPay::Company.create(attrs) }.to raise_error(expected_error)
  end

  it "can't create a company where the company identifier can't be found" do
    stubbed_params = {
      "CountryCode" => "GB",
      "Email" => "chris@bananas.com",
      "Identifier" => "00000001",
      "Phone" => "555 12345",
    }

    stub_request = stub_post_request("/Customer/CreateCompany",
                                     stubbed_params,
                                     "company/invalid_identifier.json")

    attrs = {
      email: "chris@bananas.com", identifier: "00000001", phone: "555 12345"
    }
    expected_error = ShieldPay::Errors::InvalidCompanyIdentifier
    expect { ShieldPay::Company.create(attrs) }.to raise_error(expected_error)
  end
end
