require 'rails_helper'

RSpec.describe Country, type: :model do
  subject(:country) { FactoryGirl.create :country }

  context 'Validation' do
    it { expect(country).to validate_presence_of(:name) }
    it { expect(country).to validate_uniqueness_of(:name).case_insensitive }
  end

  context 'Associations' do
    it { expect(country).to have_many(:addresses) }
  end

  describe 'Before save' do
    it 'should capitalize #name' do
      country = FactoryGirl.create(:country, name: 'united states')
      expect(country.name).to eq 'United States'
    end
  end

  describe '#to_s' do
    it 'should return #name' do
      expect(country.to_s).to eq(country.name)
    end
  end
end
