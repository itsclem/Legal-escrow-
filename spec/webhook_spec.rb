require 'spec_helper'

describe ShieldPay::Webhook do

  it 'returns true if updated successfully' do
    stubbed_params = {
      "Url" => "https://www.testing.com/shieldpay/webhook",
      "WebhookEventBinding" =>
      [
        { "EventId" => "1" },
        { "EventId" => "2" }
      ].to_s
    }

    stub_request = stub_post_request("/Webhook/Add",
                                     stubbed_params,
                                     "webhook/added_successfully.json")

    webhook_params = {
      url: "https://www.testing.com/shieldpay/webhook",
      events: [ :initiated, :add_fund ]
    }
    result = ShieldPay::Webhook.add(webhook_params)
    expect(result).to be_truthy
  end

  it 'raises an exception if an event is not defined' do
    webhook_params = {
      url: "https://www.testing.com/shieldpay/webhook",
      events: [ :bananas ]
    }
    expect { ShieldPay::Webhook.add(webhook_params) }.to raise_error(ShieldPay::Errors::RequiredField)
  end

  it 'raises an exception if no url' do
    webhook_params = {
      events: [ :add_fund ]
    }
    expect { ShieldPay::Webhook.add(webhook_params) }.to raise_error(ShieldPay::Errors::RequiredField)
  end
end
