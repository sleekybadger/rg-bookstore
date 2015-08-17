require 'rails_helper'

RSpec.describe Delivery, type: :model do
  subject(:delivery) { FactoryGirl.create :delivery }

  context 'Validation' do
    it { expect(delivery).to validate_presence_of(:name) }
    it { expect(delivery).to validate_presence_of(:price) }
    it { expect(delivery).to validate_numericality_of(:price) }
  end

  context 'Associations' do
    it { expect(delivery).to have_many(:orders) }
  end

  describe '#to_s' do
    it 'returns #name' do
      expect(delivery.to_s).to eq(delivery.name)
    end
  end

  describe '#beauty_price' do
    it 'returns #price, with two signs after comma' do
      expect(FactoryGirl.build(:delivery, price: 1.2).beauty_price).to eq('1.20')
    end
  end
end
