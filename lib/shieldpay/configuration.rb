module ShieldPay
  class Configuration
    attr_accessor :org_key
    attr_accessor :country_code
    attr_accessor :debug
    attr_accessor :endpoint_url

    def initialize
      @org_key = nil
      @country_code = nil
      @debug = nil
      @endpoint_url = "https://apiuat.shieldpay.com"
    end
  end
end
