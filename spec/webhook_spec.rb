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
        ]
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

    it 'assumes all events if none set' do
      stubbed_params = {
        "Url" => "https://www.testing.com/shieldpay/webhook",
        "WebhookEventBinding" =>
        [
          { "EventId" => "1" }, { "EventId" => "2" }, { "EventId" => "3" },
          { "EventId" => "4" }, { "EventId" => "5" }, { "EventId" => "6" },
          { "EventId" => "7" }, { "EventId" => "8" }, { "EventId" => "9" },
          { "EventId" => "10" }, { "EventId" => "11" }, { "EventId" => "12" },
          { "EventId" => "13" }, { "EventId" => "14" }
        ]
      }

      stub_request = stub_post_request("/Webhook/Add",
                                       stubbed_params,
                                       "webhook/added_successfully.json")

      webhook_params = {
        url: "https://www.testing.com/shieldpay/webhook"
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

  describe 'event_name_from_id' do
    it 'finds the event name from the id' do
      actual = ShieldPay::Webhook.event_name_from_id("13")
      expect(actual).to eq(:refund_in_progress)
    end

    it "doesn't matter if the id is a number" do
      actual = ShieldPay::Webhook.event_name_from_id(2)
      expect(actual).to eq(:add_fund)
    end
  end
end
