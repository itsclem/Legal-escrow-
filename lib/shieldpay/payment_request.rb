module ShieldPay
  class PaymentRequest

    attr_accessor :payment_request_key

    def self.create_with_email(params={})
      params[:batch_reference] = 0
      params[:currency_code] ||= ShieldPay.configuration.default_currency
      params[:target_currency_code] ||= ShieldPay.configuration.default_currency

      response = Request.new.post("/Transaction/PaymentRequestByEmailId",
                                  params)
      payment_request_key = response['Data']
      new.tap {|pr| pr.payment_request_key = payment_request_key }
    end

  end
end