require 'rails_helper'

RSpec.describe Category, type: :model do
  subject(:category) { FactoryGirl.create :category }

  context 'Validation' do
    it { expect(category).to validate_presence_of(:title) }
    it { expect(category).to validate_uniqueness_of(:title).case_insensitive }
  end

  context 'Associations' do
    it { expect(category).to have_many(:books) }
  end

  describe 'Before save' do
    it 'should capitalize #title' do
      category = FactoryGirl.create(:category, title: 'novel')
      expect(category.title).to eq 'Novel'
    end
  end

  describe '#to_s' do
    it 'should return #title' do
      expect(category.to_s).to eq(category.title)
    end
  end
end
