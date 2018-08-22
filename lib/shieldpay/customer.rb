module ShieldPay
  class Customer
    extend Helpers

    attr_accessor :customer_key, :kyc_verified, :display_name, :email,
                  :mobile_no

    # Contact Params
    # Parameter      Optional?  Description
    # display_name   no	       The customer's name
    # email	         no	       Email address for contact person
    # mobile_no      no 	     This customer's mobile number
    def self.create(params={})
      stringify_keys!(params)
      response = Request.new.post("/Customer/CreateRegisterCustomer", params)

      customer_key = response["Data"].dig("CustomerKey")
      kyc_verified = response["Data"].dig("KYCStatus") == "Verified"
      new.tap do |c|
        c.customer_key = customer_key
        c.kyc_verified = kyc_verified
        c.display_name = params["display_name"]
        c.email = params["email"]
        c.mobile_no = params["mobile_no"]
      end
    end


    # Verification Params
    # Parameter
    # title
    # first_name
    # last_name
    # gender
    # date_of_birth
    # flat_number
    # building_number
    # street
    # state
    # town
    # post_code
    # country
    # customer_key
    def self.kyc_verify(params={})
      stringify_keys!(params)
      if params["customer_key"].strip.empty?
        raise ShieldPay::Errors::RequiredField.new("customer_key field is required to verify this customer. You can create a customer_key field using the Customer.create method")
      end
      params["postcode"] = params.delete("post_code")
      params["gender"] = params.delete("gender").to_s.upcase
      response = Request.new.post("/Customer/KYCVerification", params)
      kyc_verified = response["Data"].dig("AddressVerified")
      new.tap do |c|
        c.kyc_verified = kyc_verified
      end
    end

    def kyc_verified?
      @kyc_verified
    end

  end
end
