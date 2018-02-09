module ShieldPay
  class Customer
    attr_accessor :customer_key, :display_name, :email, :mobile_no

    # Contact Params
    # Parameter      Optional?  Description
    # display_name   no	       The customer's name
    # email	         no	       Email address for contact person
    # mobile_no      no 	     This customer's mobile number
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
