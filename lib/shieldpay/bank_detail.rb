module ShieldPay
  class BankDetail

    # Contact Params
    # Parameter           Optional?  Description
    # account_holder_name  no 	     Name of the bank account holder
    # bank_account_number  no        Bank account number
    # customer_key         no        ShieldPay ID for this customer
    # currency_code        no	       Currently GBP, EUR, USD or SGD
    # routing_number       no 	     Sort code or routing number
    # iban                 yes       IBAN (if this isn't set, it defaults to the bank account number)
    def self.update(params={})
      if !params[:iban] || params[:iban].size == 0
        params[:iban] = params[:bank_account_number]
      end
      response = Request.new.post("/BankDetail/AddBankDetail", params)
      response.dig("Data", "Result", "IsSuccess")
    end

  end
end
