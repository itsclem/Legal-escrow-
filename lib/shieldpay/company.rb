module ShieldPay
  class Company

    attr_accessor :country_code, :email, :identifier, :phone, :customer_key,
                  :name, :address, :locality, :post_code, :created_on

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
        c.customer_key = customer_key
        c.country_code = params[:country_code]
        c.phone = params[:phone]
        c.identifier = params[:identifier]
      end
    end

    def initialize(attrs)
      @email = attrs["Email"]
      @name = attrs["CompanyName"]
      @address = attrs["Address"]
      @locality = attrs["Locality"]
      @post_code = attrs["PostalCode"]
      @created_on = Time.parse(attrs["CreatedOn"])
    end

  end
end
