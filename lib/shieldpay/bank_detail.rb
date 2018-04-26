module ShieldPay
  class BankDetail

    # Contact Params
    # Parameter           Optional?  Description
    # customer_key         no	       ShieldPay ID for this customer
    # currency_code        no	       Currently GBP, EUR, USD or SGD
    # account_holder_name  no 	     Name of the bank account holder
    # routing_number       no 	     Sort code or routing number
    # bank_account_number  no        Bank account number
    # iban                 no        IBAN
    def self.create(params={})
      Request.new.post("/BankDetail/AddBankDetail", params)
    end

  end
end
