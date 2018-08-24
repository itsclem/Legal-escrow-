module ShieldPay
  class Transaction
    extend Helpers

    attr_accessor :status_id


    # Webhook Params
    # Parameter           Optional?  Description
    # customer_id         no 	       The customer id of either the sender or the
    #                                receiver of this transaction
    # transaction_id      no         The transaction id to look up
    def self.get_status(input_params={})
      stringify_keys!(input_params)
      response = Request.new.post("/Transaction/GetPaymentStatus", input_params)
      response.dig("Data", "StatusId")
    end
  end
end
