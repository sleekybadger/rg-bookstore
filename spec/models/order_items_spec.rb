require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  subject(:order_item) { FactoryGirl.create :order_item }

  context 'Validation' do
    it { expect(order_item).to validate_presence_of(:order) }
    it { expect(order_item).to validate_presence_of(:book) }
    it { expect(order_item).to validate_presence_of(:quantity) }

    it { expect(order_item).to validate_numericality_of(:quantity).only_integer.is_greater_than_or_equal_to(1) }
  end

  context 'Associations' do
    it { expect(order_item).to belong_to(:order) }
    it { expect(order_item).to belong_to(:book) }
  end

  describe '#total_price' do
    it 'should return book#price * order_item#quantity' do
      expect(order_item.total_price).to eq(order_item.book.price * order_item.quantity)
    end
  end

  describe '#reduce_quantity' do
    let(:order_item) { FactoryGirl.create :order_item, quantity: 5 }

    it 'should reduce order item quantity' do
      order_item.reduce_quantity(1)
      expect(order_item.quantity).to eq(4)
    end

    it 'should save order item, if result quantity > 0' do
      expect(order_item).to receive(:save)
      order_item.reduce_quantity(1)
    end

    it 'should destroy order item, if result quantity <= 0' do
      expect(order_item).to receive(:destroy)
      order_item.reduce_quantity(5)
    end
  end
end
