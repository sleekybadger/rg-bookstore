require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryGirl.create :user }

  context 'Validation' do
    it { expect(user).to validate_presence_of(:email) }
    it { expect(user).to validate_presence_of(:first_name) }
    it { expect(user).to validate_presence_of(:last_name) }

    it { expect(user).to validate_uniqueness_of(:email) }

    it { expect(user).to allow_value('johndou@gmail.com').for(:email) }
    it { expect(user).not_to allow_value('johndougmail.com').for(:email) }
  end

  context 'Associations' do
    it { expect(user).to have_one(:billing_address).dependent(:destroy) }
    it { expect(user).to have_one(:shipping_address).dependent(:destroy) }
    it { expect(user).to have_many(:reviews).dependent(:destroy) }
    it { expect(user).to have_many(:orders) }
  end

  describe '#to_s' do
    it 'should return #fist_name + #last_name' do
      expect(user.to_s).to eq("#{user.first_name} #{user.last_name}")
    end
  end

  describe '#is_left_review?' do
    it 'should return true if user left review for book' do
      book = FactoryGirl.create :book

      FactoryGirl.create :review, book: book, user: user

      user.reviews.reload

      expect(user.is_left_review?(book)).to be true
    end

    it 'should return false if user did not leave review for book' do
      book = FactoryGirl.create :book

      FactoryGirl.create :review

      user.reviews.reload

      expect(user.is_left_review?(book)).to be false
    end
  end
end
