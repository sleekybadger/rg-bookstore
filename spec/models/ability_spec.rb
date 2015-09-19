require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }
  let(:user) { nil }

  context 'user is admin' do
    let(:user) { FactoryGirl.create :user, is_admin: true }

    it { expect(ability).to be_able_to(:access, :rails_admin) }
    it { expect(ability).to be_able_to(:manage, :all) }
  end

  context 'user is logged' do
    let(:user) { FactoryGirl.create :user }

    it { expect(ability).to be_able_to(:read, Wish) }
    it { expect(ability).to be_able_to(:destroy, Wish.new(user: user)) }
    it { expect(ability).to be_able_to(:create, Wish) }

    it { expect(ability).to be_able_to(:update, user) }
    it { expect(ability).to be_able_to(:destroy, user) }
    it { expect(ability).to be_able_to(:read, user) }

    it { expect(ability).to be_able_to(:read, user.build_billing_address) }
    it { expect(ability).to be_able_to(:update, user.build_billing_address) }
    it { expect(ability).to be_able_to(:destroy, user.build_billing_address) }
    it { expect(ability).to be_able_to(:create, Shopper::BillingAddress) }
    it 'should not to be able to create Shopper::BillingAddress' do
      FactoryGirl.create :billing_address, addressable: user
      expect(ability).not_to be_able_to(:create, Shopper::BillingAddress)
    end

    it { expect(ability).to be_able_to(:read, user.build_shipping_address) }
    it { expect(ability).to be_able_to(:update, user.build_shipping_address) }
    it { expect(ability).to be_able_to(:destroy, user.build_shipping_address) }
    it { expect(ability).to be_able_to(:create, Shopper::ShippingAddress) }
    it 'should not to be able to create Shopper::ShippingAddress' do
      FactoryGirl.create :shipping_address, addressable: user
      expect(ability).not_to be_able_to(:create, Shopper::ShippingAddress)
    end

    it 'should be able to :add_review_to_book' do
      book = FactoryGirl.create :book

      expect(ability).to be_able_to(:add_review_to_book, Book, book)
    end

    it 'should not be able to :add_review_to_book' do
      book = FactoryGirl.create :book

      FactoryGirl.create :review, :approved, book: book, user: user

      expect(ability).not_to be_able_to(:add_review_to_book, book)
    end
  end

  context 'user not logged' do
    it { expect(ability).to be_able_to(:read, Book) }
    it { expect(ability).to be_able_to(:read, Category) }
    it { expect(ability).to be_able_to(:read, Author) }
  end
end
