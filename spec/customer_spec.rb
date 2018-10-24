require 'spec_helper'

describe ShieldPay::Customer do
  it 'creates a customer' do
    stubbed_params = {
      "Email" => "chris@bananas.com",
      "MobileNo" => "555 12345",
      "DisplayName" => "Mr Bananas"
    }

    stub_request = stub_post_request("/Customer/CreateRegisterCustomer",
                                     stubbed_params,
                                     "customer/created_successfully.json")

    customer = ShieldPay::Customer.create(display_name: "Mr Bananas",
                                          email: "chris@bananas.com",
                                          mobile_no: "555 12345")
    expect(customer.customer_key).to eq("ZZZZZZZZZZZ=")
    expect(customer.kyc_verified?).to be_truthy
  end

  it "can't create a customer where the email already exists" do
    stubbed_params = {
      "DisplayName" => "Mr Bananas",
      "Email" => "chris@bananas.com",
      "MobileNo" => "555 12345"
    }

    stub_request = stub_post_request("/Customer/CreateRegisterCustomer",
                                     stubbed_params,
                                     "customer/email_exists.json")

    attrs = {
      display_name: "Mr Bananas", email: "chris@bananas.com",
      mobile_no: "555 12345",
    }
    expected_error = ShieldPay::Errors::CustomerEmailExists
    expect { ShieldPay::Customer.create(attrs) }.to raise_error(expected_error)
  end

  it 'successfully verifies KYC' do
    stubbed_params = {
      "Title" => "Mr",
      "FirstName" => "Dave",
      "LastName" => "Bananas",
      "Gender" => "M",
      "DateOfBirth" => "1954-11-02",
      "FlatNumber" => "16 Abc Building",
      "BuildingNumber" => "99",
      "Street" => "Geezer Street",
      "State" => "London",
      "Town" => "London",
      "Postcode" => "B1 B22",
      "Country" => "United Kingdom",
      "CustomerKey" => "XXXXXX"
    }

    stub_request = stub_post_request("/Customer/KYCVerification",
                                     stubbed_params,
                                     "customer/kyc_verified_successfully.json")

    attrs = {
      title: "Mr", first_name: "Dave", last_name: "Bananas", gender: "m",
      date_of_birth: Date.parse("02-11-1954"), flat_number: "16 Abc Building",
      building_number: "99", street: "Geezer Street", state: "London",
      town: "London", postcode: "B1 B22", country: "United Kingdom",
      customer_key: "XXXXXX"
    }
    result = ShieldPay::Customer.kyc_verify(attrs)
    expect(result.kyc_verified?).to be_truthy
  end
end
