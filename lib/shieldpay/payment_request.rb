module ShieldPay
  class PaymentRequest
    extend Helpers

    attr_accessor :payment_request_key

    def self.create_with_email(params={})
      stringify_keys!(params)
      params["batch_reference"] = "0"
      params["currency_code"] ||= ShieldPay.configuration.default_currency
      params["target_currency_code"] ||= ShieldPay.configuration.default_currency
      params["amount"] = params["amount"].to_s # must be a string for some reason
      params["fee_receiver_amount"] = params["fee_receiver_amount"].to_s # must be a string for some reason

      response = Request.new.post("/Transaction/PaymentRequestByEmailId",
                                  params)
      payment_request_key = response['Data']
      new.tap {|pr| pr.payment_request_key = payment_request_key }
    end

  end
end
