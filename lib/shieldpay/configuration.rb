module ShieldPay
  class Configuration
    attr_accessor :country_code
    attr_accessor :debug
    attr_accessor :default_currency
    attr_accessor :endpoint_url
    attr_accessor :org_key

    def initialize
      @org_key = nil
      @country_code = nil
      @debug = nil
      @default_currency = nil
      @endpoint_url = "https://apiuat.shieldpay.com"
    end
  end
end
