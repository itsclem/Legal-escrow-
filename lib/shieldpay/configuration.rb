module ShieldPay
  class Configuration
    attr_accessor :country_code
    attr_accessor :debug
    attr_accessor :default_currency
    attr_accessor :org_key
    attr_accessor :uat

    def initialize
      @org_key = nil
      @country_code = nil
      @debug = nil
      @default_currency = nil
      @uat = false
    end

    def api_endpoint_url
      if @uat
        "https://apiuat.shieldpay.com"
      else
        "https://api.shieldpay.com"
      end
    end

    def endpoint_url
      if @uat
        "https://uat.shieldpay.com"
      else
        "https://www.shieldpay.com"
      end
    end
  end
end
