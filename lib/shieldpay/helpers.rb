module ShieldPay
  module Helpers
    def stringify_keys(hash)
      hash.inject({}) do |hash, (key, value)|
        value = value.stringify_keys if value.is_a?(Hash)
        hash[key.to_s] = value
        hash
      end
    end

    def stringify_keys!(hash)
      hash.replace(stringify_keys(hash))
    end
  end
end
