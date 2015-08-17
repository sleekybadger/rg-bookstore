require 'rails_helper'

RSpec.describe ShippingAddress, type: :model do
  it 'should inherit Address' do
    address = ShippingAddress.new

    expect(address.class.superclass).to eq(Address)
  end
end
