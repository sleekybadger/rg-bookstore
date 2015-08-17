require 'rails_helper'

RSpec.describe Book, type: :model do
  subject(:book) { FactoryGirl.create :book }

  context 'Validation' do
    it { expect(book).to validate_presence_of(:title) }
    it { expect(book).to validate_presence_of(:price) }
    it { expect(book).to validate_numericality_of(:price) }
    it { expect(book).to validate_length_of(:short_description).is_at_most(500) }
    it { expect(book).to validate_length_of(:full_description).is_at_most(2000) }
  end

  context 'Associations' do
    it { expect(book).to belong_to(:author) }
    it { expect(book).to belong_to(:category) }
    it { expect(book).to have_many(:reviews).dependent(:destroy) }
    it { expect(book).to have_many(:order_items).dependent(:destroy) }
  end

  context 'Scopes' do
    describe '.best_sellers' do
      it 'should return best selling books' do
        best_seller_order = FactoryGirl.create :order, state: 3
        best_seller_item = FactoryGirl.create :order_item, book: book, order: best_seller_order

        best_seller_order.order_items.reload

        expect(Book.best_sellers.first.id).to eq(best_seller_item.book_id)
      end
    end
  end

  describe 'Before save' do
    it 'should capitalize title' do
      book = FactoryGirl.create(:book, title: 'treasure island')
      expect(book.title).to eq 'Treasure Island'
    end
  end

  describe '#to_s' do
    it 'should return title' do
      expect(book.to_s).to eq book.title
    end
  end

  describe '#calculate_average_rating' do
    let(:book) { FactoryGirl.create :book_with_reviews }

    it 'should return floor average rating for book review#rating' do
      rating = (book.reviews.map(&:rating).inject(&:+) / book.reviews.size).floor

      expect(book.calculate_average_rating).to eq rating
    end
  end

  describe '#calculate_average_rating!' do
    let(:book) { FactoryGirl.create :book_with_review }

    it 'should change book#average_rating' do
      average_rating = book.average_rating

      FactoryGirl.create :review, book: book, rating: 5

      book.reviews.reload

      book.calculate_average_rating!

      expect(book.average_rating).not_to eq average_rating
    end
  end
end
