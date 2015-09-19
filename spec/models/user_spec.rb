require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryGirl.create :user }

  describe 'Validation' do
    it { expect(user).to validate_presence_of(:email) }
    it { expect(user).to validate_presence_of(:first_name) }
    it { expect(user).to validate_presence_of(:last_name) }

    it { expect(user).to validate_uniqueness_of(:email) }

    it { expect(user).to allow_value('johndou@gmail.com').for(:email) }
    it { expect(user).not_to allow_value('johndougmail.com').for(:email) }
  end

  describe 'Associations' do
    it { expect(user).to have_one(:billing_address).dependent(:destroy) }
    it { expect(user).to have_one(:shipping_address).dependent(:destroy) }
    it { expect(user).to have_many(:reviews).dependent(:destroy) }
    it { expect(user).to have_many(:orders).dependent(:nullify) }
    it { expect(user).to have_many(:wishes).dependent(:destroy) }
  end

  describe '.from_omniauth' do
    context 'when user in database' do
      it 'should return user' do
        user = FactoryGirl.create :user, provider: 'facebook', uid: 1
        auth = double('Auth', provider: 'facebook', uid: 1)

        expect(User.from_omniauth(auth)).to eq(user)
      end
    end

    context 'when user not in database' do
      it 'should create new user from info' do
        old_count = User.count
        info = double('Info', email: 'johndou@gmail.com', first_name: 'john', last_name: 'dou')
        auth = double('Auth', provider: 'facebook', uid: 1, info: info)

        User.from_omniauth(auth)

        expect(User.count).to eq(old_count + 1)
      end
    end
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
