require 'rails_helper'

RSpec.describe Wish, type: :model do
  subject(:wish) { FactoryGirl.create(:wish) }

  describe 'Validation' do
    it { expect(wish).to validate_presence_of(:book) }
    it { expect(wish).to validate_presence_of(:user) }
  end

  describe 'Associations' do
    it { expect(wish).to belong_to(:book) }
    it { expect(wish).to belong_to(:user) }
  end
end
