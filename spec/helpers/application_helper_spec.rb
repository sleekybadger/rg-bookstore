require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '.cart_items' do
    it 'should return #cart_items of @current_order' do
      order_with_items = FactoryGirl.create :order_with_items
      @current_order = order_with_items

      expect(cart_items).to eq(order_with_items.order_items)
    end
  end
end
