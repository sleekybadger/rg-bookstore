require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '.cart_items' do
    it 'should return #cart_items of @current_order' do
      order_with_items = FactoryGirl.create :order_with_items
      @current_order = order_with_items

      expect(cart_items).to eq(order_with_items.order_items)
    end
  end

  describe '.title' do
    it 'should sets content for :title' do
      helper.title 'yoyoy'
      expect(helper.content_for(:title)).to match('yoyoy')
    end
  end

  describe '.glyph_icon' do
    it 'should return i tag' do
      expect(helper.glyph_icon :star).to have_selector('i')
    end

    it 'should add class glyphicon' do
      expect(helper.glyph_icon :star).to have_selector('.glyphicon')
    end

    it 'should add first_param as class with + glyphicon-' do
      expect(helper.glyph_icon :star).to have_selector('.glyphicon-star')
    end

    it 'should transform snake case to dashed' do
      expect(helper.glyph_icon :super_star).to have_selector('.glyphicon-super-star')
    end
  end

  describe '.beauty_price' do
    it 'should format to two decimals after point' do
      expect(helper.beauty_price(1)).to eq('1.00')
    end
  end

  describe '.current_p?' do
    before { allow(helper).to receive_message_chain(:request, :path) { '/yo' } }

    it { expect(helper.current_p?('/yo')).to be_truthy }
    it { expect(helper.current_p?('/pam')).to be_falsey }
  end
end
