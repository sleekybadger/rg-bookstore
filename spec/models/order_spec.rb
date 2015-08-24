require 'rails_helper'

RSpec.describe Order, type: :model do
  subject(:order) { FactoryGirl.create :order }

  context 'Enum' do
    it { expect(order).to define_enum_for(:state).with(%i(in_progress in_queue in_delivery delivered canceled)) }
  end

  context 'Associations' do
    it { expect(order).to belong_to(:delivery) }
    it { expect(order).to belong_to(:user) }
    it { expect(order).to have_one(:billing_address).dependent(:destroy) }
    it { expect(order).to have_one(:shipping_address).dependent(:destroy) }
    it { expect(order).to have_one(:credit_card).dependent(:destroy) }
    it { expect(order).to have_many(:order_items).dependent(:destroy) }
  end

  context 'Nested attributes' do
    it { expect(order).to accept_nested_attributes_for(:billing_address) }
    it { expect(order).to accept_nested_attributes_for(:shipping_address) }
    it { expect(order).to accept_nested_attributes_for(:credit_card) }
  end

  context 'States' do
    describe ':in_progress' do
      it 'should be an initial state' do
        expect(order).to be_in_progress
      end
    end

    describe '#place_order' do
      it 'should allow transition from :in_progress to :in_queue' do
        order.place_order

        expect(order).to be_in_queue
      end

      it 'should not allow transition from other state to :in_queue' do
        order.in_delivery!

        expect(order).not_to be_in_queue
      end

      it 'should not allow transition to :in_queue without billing_address' do
        order.update(billing_address: nil)

        expect(order.place_order).to be false
      end

      it 'should not allow transition to :in_queue without shipping_address' do
        order.update(shipping_address: nil)

        expect(order.place_order).to be false
      end

      it 'should not allow transition to :in_queue without delivery' do
        order.update(delivery: nil)

        expect(order.place_order).to be false
      end

      it 'should not allow transition to :in_queue without credit card' do
        order.update(credit_card: nil)

        expect(order.place_order).to be false
      end
    end
  end

  describe '#items_total_price' do
    let(:order) { FactoryGirl.create :order_with_items }

    it 'should return sum of #order_items#total_price' do
      sum = order.order_items.map(&:total_price).inject(&:+)

      expect(order.items_total_price).to eq(sum)
    end
  end

  describe '#total_price' do
    let(:order) { FactoryGirl.create :order_with_items }

    it 'should return sum of #items_total_price + #delivery.price' do
      sum = order.items_total_price + order.delivery.price

      expect(order.total_price).to eq(sum.round(2))
    end
  end
end
