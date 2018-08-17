module ShieldPay
  class Webhook
    extend Helpers

    attr_accessor :events, :id, :url

    EVENT_CODES = {
      initiated: "1", add_fund: "2", accepted: "3", sender_complete: "4",
      receiver_complete: "5", funds_available: "6",
      receiver_decline_before_accept: "7", sender_cancelled_before_funded: "8",
      payment_generated: "9", funding_pending: "10",
      sender_cancelled_after_funded: "11", refund_in_progress: "12",
      customer_status: "13"
    }

    # Webhook Params
    # Parameter           Optional?  Description
    # url                  no 	     The url that shieldpay will call for webhooks
    # events               no        The events that this webhook will monitor
    #                                (defaults to all events)
    #                                Options are:
    #                                :initated, :add_fund, :accepted, :sender_complete,
    #                                :receiver_complete, :funds_available,
    #                                :receiver_decline_before_accept,
    #                                :sender_cancelled_before_funded,
    #                                :payment_generated, :funding_pending,
    #                                :sender_cancelled_after_funded,
    #                                :refund_in_progress, :customer_status
    def self.add(input_params={})
      stringify_keys!(input_params)
      url = input_params["url"]
      if url.nil? || url.size == 0
        raise Errors::RequiredField.new("url is a required field")
      end
      params = { "Url" => url }
      events = input_params["events"]
      event_codes =  if events.nil? || events.size == 0
        EVENT_CODES.values
      else
        events.collect do |event|
          event_code = EVENT_CODES[event.to_sym]
          if event_code.nil?
            raise Errors::RequiredField.new("#{event} is not a valid event")
          end
          event_code
        end
      end


      params[:webhook_event_binding] = event_codes.collect do |event_code|
        { "EventId" => event_code }
      end

      response = Request.new.post("/Webhook/Add", params)
      response.dig("coreRes", "userMessage") == "Request successful"
    end

    # returns all the webhooks registered with ShieldPay
    def self.all
      response = Request.new.post("/Webhook/AllByOrgKey", {})
      response["Data"].collect do |webhook|
        new(webhook["WebhookId"],
            webhook["URL"],
            webhook["WebhookEventBinding"])
      end
    end

    # takes in the webhook id to delete a webhook
    def self.delete(id)
      params = {
        webhook_id: id
      }
      response = Request.new.post("/Webhook/WebhookDelete", params)
      response["Data"] == "Success"
    end

    def initialize(id, url, events)
      @id = id
      @url = url
      @events = parse_events(events)
    end

    private

    def parse_events(events)
      @events = events.collect do |hsh|
        event_name = hsh["EventName"]
        # remove spaces
        event_name = event_name.tr(" ", "-")
        underscore(event_name).to_sym
      end
    end

    def underscore(string)
      string.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end

  end
end
