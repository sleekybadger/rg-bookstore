require 'rails_helper'

RSpec.describe Review, type: :model do
  subject(:review) { FactoryGirl.create :review }

  context 'Enum' do
    it { expect(review).to define_enum_for(:status).with(%i(unmoderated approved rejected)) }
  end

  context 'Validation' do
    it { expect(review).to validate_presence_of(:note) }
    it { expect(review).to validate_presence_of(:rating) }
    it { expect(review).to validate_presence_of(:book) }
    it { expect(review).to validate_presence_of(:user) }
    it { expect(review).to validate_presence_of(:status) }

    it { expect(review).to validate_inclusion_of(:rating).in_range(1..5) }
  end

  context 'Associations' do
    it { expect(review).to belong_to(:user) }
    it { expect(review).to belong_to(:book) }
  end

  context 'After save' do
    it 'should call #calculate_average_rating! on self#book' do
      expect(review.book).to receive(:calculate_average_rating)
      review.save
    end
  end

  context 'States' do
    describe ':unmoderated' do
      it 'should be an initial state' do
        expect(review).to be_unmoderated
      end

      it 'should allow transition to :approved' do
        review.approve!

        expect(review).to be_approved
      end

      it 'should allow transition to :rejected' do
        review.reject!

        expect(review).to be_rejected
      end
    end

    describe ':approved' do
      let(:review) { FactoryGirl.create(:review, :approved) }

      it 'should allow transition to :rejected' do
        review.reject!
        expect(review).to be_rejected
      end
    end

    describe ':rejected' do
      let(:review) { FactoryGirl.create(:review, :rejected) }

      it 'should allow transition to :approved' do
        review.approve!
        expect(review).to be_approved
      end
    end
  end
end
