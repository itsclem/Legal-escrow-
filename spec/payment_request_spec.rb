require 'spec_helper'

describe ShieldPay::PaymentRequest do

  it 'creates a payment request with email ids' do
    stubbed_params = {
      "FromEmail" => "supplier@bananas.com",
      "RequestFrom" => "eComWrapper: Normal",
      "Amount" => "100.45",
      "CurrencyCode" => "GBP",
      "Description" => "Load of bananas",
      "ToEmail" => "dave@bananafans.com",
      "TargetCurrencyCode" => "GBP",
      "BatchReference" => "0",
      "FeeReceiverAmount" => "15.5",
      "FeeReceiverEmail" => "bill@bananashop.com"
    }

    expected_file = "payment_request/created_successfully.json"
    stub_request = stub_post_request("/Transaction/PaymentRequestByEmailId",
                                     stubbed_params,
                                     expected_file)

    attrs = {
      from_email: "supplier@bananas.com",
      request_from: "eComWrapper: Normal",
      amount: 100.45,
      currency_code: "GBP",
      description: "Load of bananas",
      to_email: "dave@bananafans.com",
      fee_receiver_amount: 15.50,
      fee_receiver_email: "bill@bananashop.com"
    }
    payment_request = ShieldPay::PaymentRequest.create_with_email(attrs)
    expect(payment_request.payment_request_key).to eq("ZZZZZZZZZZZ=")

  end

end
