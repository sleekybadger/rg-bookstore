require 'rails_helper'

RSpec.describe 'books/index', type: :view do
  let(:book) { FactoryGirl.create :book }
  let(:books) { Kaminari.paginate_array([book]).page(1) }
  let(:categories) { Kaminari.paginate_array([book.category]).page(1) }

  before do
    assign(:books, books)
    assign(:categories, categories)

    render
  end

  it { expect(view).to render_template(partial: 'books/_books_list', count: 1) }
  it { expect(view).to render_template(partial: 'categories/_categories_list', count: 1) }
end

RSpec.describe 'books/_books_list', type: :view do
  let(:book) { FactoryGirl.create :book }
  let(:books) { Kaminari.paginate_array([book]).page(1) }

  before { render partial: 'books/books_list', locals: { books: books } }

  it { expect(rendered).to match('.books-list') }
  it { expect(rendered).to match(book.to_s) }
  it { expect(rendered).to match(book.cover.thumb.url) }
end

RSpec.describe 'books/show', type: :view do
  let(:book) { FactoryGirl.create :book }
  # let(:order_item) { FactoryGirl.create :order_item }
  let(:user) { FactoryGirl.create :user }
  let!(:review) { FactoryGirl.create :review, :approved, book: book, user: user }

  before do
    assign(:book, book)
    # assign(:order_item, order_item)
    assign(:user, user)
    allow(view).to receive(:current_user) { user }
  end

  context 'required info' do
    before do
      render
    end

    it { expect(rendered).to match(book.to_s) }
    it { expect(rendered).to match(book.cover.url) }
    it { expect(rendered).to match('%.2f' % book.price) }
  end

  context 'with author' do
    before do
      render
    end

    it { expect(rendered).to match(book.author.to_s) }
  end

  context 'book review' do
    context 'user logged and not left review' do
      before do
        allow(user).to receive(:is_left_review?) { false }
        render
      end

      it { expect(rendered).to match(new_book_review_path(book)) }
    end

    context 'user already left review' do
      before do
        allow(user).to receive(:is_left_review?) { true }
        render
      end

      it { expect(rendered).to match(t('review.review_left')) }
    end

    context 'user not logged' do
      before do
        allow(user).to receive(:is_left_review?) { false }
        allow(view).to receive(:current_user)
        render
      end

      it { expect(rendered).to match(t('review.not_singed_in')) }
    end

    context 'book with review' do
      before do
        render
      end

      it { expect(rendered).to have_text(review.note) }
      it { expect(rendered).to have_selector('.reviews-list i.glyphicon-star', count: review.rating) }
      it { expect(rendered).to have_selector('.rating i.glyphicon-star', count: book.average_rating) }
      it { expect(rendered).to match('.reviews-list') }
      it { expect(rendered).to match(review.user.to_s) }
    end
  end
end