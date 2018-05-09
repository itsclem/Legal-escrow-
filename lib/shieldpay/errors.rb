module ShieldPay
  module Errors

    # standard errors
    class InvalidOrganizationKey     < StandardError; end
    class OrganizationKeyDoesntExist < StandardError; end
    class RequiredField              < StandardError; end

    # company errors
    class CompanyAlreadyExists     < StandardError; end
    class InvalidCompanyIdentifier < StandardError; end

    # customer errors
    class AddressNotVerified  < StandardError; end
    class CustomerEmailExists < StandardError; end
    class CustomerDoesntExist < StandardError; end

    ERROR_MATCHING = {
      "Invalid Organization key." => InvalidOrganizationKey,
      "OrganizationKey is not valid." => InvalidOrganizationKey,
      "OrganizationKey is not exists." => OrganizationKeyDoesntExist,

      "Company identifier already exist. " \
      "Please contact your system administrator" => CompanyAlreadyExists,
      "Company identifier could not be validated" => InvalidCompanyIdentifier,

      "Email already exists." => CustomerEmailExists,
      "Customer does not exist" => CustomerDoesntExist,
      "Address not verified." => AddressNotVerified,
      "Address not varified, Exception in Request" => AddressNotVerified,
    }

    def check_for_error(response_body)
      user_message = response_body['coreRes']['userMessage']
      raise_error(user_message) if has_error?(response_body)
    end

    private

    def has_error?(response_body)
      response_body['coreRes']['status'].to_i != 1
    end

    def raise_error(user_message)
      error_klass = ERROR_MATCHING[user_message] || StandardError

      raise error_klass.new(user_message)
    end

  end
end
