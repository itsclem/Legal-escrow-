module ShieldPay
  class Company

    attr_accessor :address, :country_code, :customer_key, :created_on, :email,
                  :identifier, :locality, :name, :phone, :post_code


    # Contact Params
    # Parameter      Optional?  Description
    # country_code   no	       The country code for this organization (i.e. GB) Defaults to ShieldPay.configuration.country_code
    # email	         no	       Email address for contact person
    # identifier     no	       Company number for your region (i.e. Companies House Number)
    # phone          no 	     Contact phone number for company
    def self.create(params={})
      params[:country_code] ||= ShieldPay.configuration.country_code
      path = "/Customer/CreateRegisterCustomer"
      url = ShieldPay.configuration.endpoint_url + path
      response = Request.new.post(url, params)

      customer_key = response["Data"]["CustomerKey"]
      new(response["Data"]["Data"]).tap do |c|
        c.country_code = params[:country_code]
        c.customer_key = customer_key
        c.identifier = params[:identifier]
        c.phone = params[:phone]
      end
    end

    def initialize(attrs)
      @address = attrs["Address"]
      @created_on = Time.parse(attrs["CreatedOn"])
      @email = attrs["Email"]
      @locality = attrs["Locality"]
      @name = attrs["CompanyName"]
      @post_code = attrs["PostalCode"]
    end

  end
end
