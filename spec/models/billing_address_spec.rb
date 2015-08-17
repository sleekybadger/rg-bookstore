require 'rails_helper'

RSpec.describe BillingAddress, type: :model do
  it 'should inherit Address' do
    address = BillingAddress.new

    expect(address.class.superclass).to eq(Address)
  end
end
