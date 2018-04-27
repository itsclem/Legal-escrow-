require 'spec_helper'

describe ShieldPay::BankDetail do

  it 'returns true if updated successfully' do
    stubbed_params = {
      "AccountHolderName" => "Mr Bananas",
      "BankAccountNumber" => "123456",
      "CustomerKey" => "XXX",
      "CurrencyCode" => "GBP",
      "RoutingNumber" => "303030",
      "IBAN" => "771177",
    }

    stub_request = stub_post_request("/BankDetail/AddBankDetail",
                                     stubbed_params,
                                     "bank_detail/updated_successfully.json")

    bank_detail_params = {
      account_holder_name: "Mr Bananas",
      bank_account_number: "123456",
      customer_key: "XXX",
      currency_code: "GBP",
      routing_number: "303030",
      iban: "771177"
    }

    result = ShieldPay::BankDetail.update(bank_detail_params)
    expect(result).to be_truthy
  end

  it 'sets IBAN to the same as bank_account_number if blank' do
    stubbed_params = {
      "AccountHolderName" => "Mr Bananas",
      "BankAccountNumber" => "123456",
      "CustomerKey" => "XXX",
      "CurrencyCode" => "GBP",
      "RoutingNumber" => "303030",
      "IBAN" => "123456",
    }

    stub_request = stub_post_request("/BankDetail/AddBankDetail",
                                     stubbed_params,
                                     "bank_detail/updated_successfully.json")

    bank_detail_params = {
      account_holder_name: "Mr Bananas",
      bank_account_number: "123456",
      customer_key: "XXX",
      currency_code: "GBP",
      routing_number: "303030",
    }

    result = ShieldPay::BankDetail.update(bank_detail_params)
    expect(result).to be_truthy
  end

end
