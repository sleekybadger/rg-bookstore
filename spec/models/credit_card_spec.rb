require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  subject(:credit_card) { FactoryGirl.create :credit_card }

  context 'Validation' do
    it { expect(credit_card).to validate_presence_of(:number) }
    it { expect(credit_card).to validate_presence_of(:expiration_month) }
    it { expect(credit_card).to validate_presence_of(:expiration_year) }
    it { expect(credit_card).to validate_presence_of(:cvv) }

    it { expect(credit_card).to allow_value(1234123412341234).for(:number) }
    it { expect(credit_card).not_to allow_value(1234).for(:number) }
    it { expect(credit_card).not_to allow_value(12341234123412341234).for(:number) }

    it { expect(credit_card).to validate_numericality_of(:cvv).only_integer }

    it { expect(credit_card).to validate_numericality_of(:expiration_month).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(12) }

    it { expect(credit_card).to validate_numericality_of(:expiration_year).only_integer }

    it 'is invalid with expiration date less then today' do
      month = Time.now.month
      year = Time.now.year - 1

      expect(FactoryGirl.build :credit_card, expiration_month: month, expiration_year: year).not_to be_valid
    end
  end

  context 'Associations' do
    it { expect(credit_card).to belong_to(:order) }
  end

  describe '#expiration_date' do
    it 'should return #expiration_month and #expiration_year' do
      expect(credit_card.expiration_date).to eq("#{credit_card.expiration_month} / #{credit_card.expiration_year}")
    end
  end

  describe '#secure_number' do
    it 'should return card number, with * instead of first 12 nums' do
      number = 1234123412341234
      expect(FactoryGirl.build(:credit_card, number: number).secure_number).to eq('**** **** **** 1234')
    end
  end
end
