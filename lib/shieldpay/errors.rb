module ShieldPay
  module Errors

    class AlreadyExists < StandardError; end
    class InvalidCompanyIdentifier < StandardError; end
    class InvalidOrganizationKey < StandardError; end

    ERROR_MATCHING = {
      "Company identifier already exist. " \
      "Please contact your system administrator" => AlreadyExists,
      "Invalid Organization key." => InvalidOrganizationKey,
      "Company identifier could not be validated" => InvalidCompanyIdentifier
    }

    def check_for_error(response_body)
      raise_error(response_body) if has_error?(response_body)
    end

    private

    def has_error?(response_body)
      response_body['coreRes']['status'].to_i == 0
    end

    def raise_error(response_body)
      error_message = response_body['coreRes']['userMessage']
      error_klass = ERROR_MATCHING[error_message] || StandardError

      raise error_klass.new(error_message)
    end

  end
end
