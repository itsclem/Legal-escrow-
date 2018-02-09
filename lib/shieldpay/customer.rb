module ShieldPay
  class Customer
    attr_accessor :customer_key, :display_name, :email, :mobile_no

    # Contact Params
    # Parameter      Optional?  Description
    # country_code   no	       The country code for this organization (i.e. GB) Defaults to ShieldPay.configuration.country_code
    # email	         no	       Email address for contact person
    # identifier     no	       Company number for your region (i.e. Companies House Number)
    # phone          no 	     Contact phone number for company
    def self.create(params={})
      response = Request.new.post("/Customer/CreateRegisterCustomer", params)

      customer_key = response["Data"]
      new.tap do |c|
        c.display_name = params[:display_name]
        c.customer_key = customer_key
        c.email = params[:email]
        c.mobile_no = params[:mobile_no]
      end
    end

  end
end
