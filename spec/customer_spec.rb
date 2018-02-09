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
    expect(customer.display_name).to eq("Mr Bananas")
    expect(customer.email).to eq("chris@bananas.com")
    expect(customer.mobile_no).to eq("555 12345")
    expect(customer.customer_key).to eq("ZZZZZZZZZZZ=")
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
end
