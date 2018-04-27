require 'spec_helper'

describe ShieldPay::BankDetail do

  it 'returns true if updated successfully' do
    stubbed_params = {
      "AccountHolderName" => "MR Bananas",
      "CustomerKey" => "XXX",
      "CurrencyCode" => "GBP",
      "RoutingNumber" => "123456",
      "IBAN" => "123456",
    }

    stub_request = stub_post_request("/BankDetail/AddBankDetail",
                                     stubbed_params,
                                     "bank_detail/updated_successfully.json")

    bank_detail_params = {
      account_holder_name: "MR Bananas",
      customer_key: "XXX",
      currency_code: "GBP",
      routing_number: "123456",
      iban: "123456"
    }

    result = ShieldPay::BankDetail.update(bank_detail_params)
    expect(result).to be_truthy
  end

end
