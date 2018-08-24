require 'spec_helper'

describe ShieldPay::Transaction do

  describe '#get_status' do
    it 'returns the status of the transaction' do
      stubbed_params = {
        "CustomerId" => "yyy",
        "TransactionId" => "xxx"
      }

      stub_request = stub_post_request("/Transaction/GetPaymentStatus",
                                       stubbed_params,
                                       "transaction/get_status.json")
      params = {
        customer_id: "yyy", transaction_id: "xxx"
      }
      status_id = ShieldPay::Transaction.get_status(params)
      expect(status_id).to eq(11)
    end
  end
end
