require 'spec_helper'

describe ShieldPay::Webhook do

  describe '#add' do

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
        events: [:initiated, :add_fund]
      }
      result = ShieldPay::Webhook.add(webhook_params)
      expect(result).to be_truthy
    end

    it 'raises an exception if an event is not defined' do
      webhook_params = {
        url: "https://www.testing.com/shieldpay/webhook",
        events: [:bananas]
      }
      expect { ShieldPay::Webhook.add(webhook_params) }.to raise_error(ShieldPay::Errors::RequiredField)
    end

    it 'raises an exception if no url' do
      webhook_params = {
        events: [:add_fund]
      }
      expect { ShieldPay::Webhook.add(webhook_params) }.to raise_error(ShieldPay::Errors::RequiredField)
    end
  end

  describe 'all' do
    it 'returns all of the webhooks' do
      stub_request = stub_post_request("/Webhook/AllByOrgKey", {},
                                       "webhook/all.json")

      result = ShieldPay::Webhook.all
      expect(result.size).to eq(2)
      expect(result[0].url).to eq("https://www.testing.com/shieldpay/webhook")
      expect(result[0].events).to eq([:initiated, :add_fund])
      expect(result[0].id).to eq("xxxxx-xxxx-xxxx-xxxx-xxxxxxx1")

      expect(result[1].url).to eq("https://www.testing.com/shieldpay/other")
      expect(result[1].events).to eq([:funds_available])
      expect(result[1].id).to eq("xxxxx-xxxx-xxxx-xxxx-xxxxxxx2")
    end
  end

  describe 'delete' do
    it 'deletes a webhook' do
      stubbed_params = {
        "WebhookId" => "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx1"
      }
      stub_request = stub_post_request("/Webhook/WebhookDelete", stubbed_params,
                                       "webhook/deleted.json")

      result = ShieldPay::Webhook.delete("xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx1")
      expect(result).to be_truthy
    end
  end
end
