require 'rails_helper'

RSpec.describe 'home/index', type: :view do
  context 'with bestsellers' do
    let(:book_one) { FactoryGirl.create :book }
    let(:book_two) { FactoryGirl.create :book }

    before do
      assign(:best_sellers, [book_one, book_two])
      render
    end

    it { expect(rendered).to have_selector('#best-sellers-carousel') }
    it { expect(rendered).to have_selector('#best-sellers-carousel .item', count: 2) }
    it { expect(rendered).to match(book_one.to_s) }
    it { expect(rendered).to match(book_one.author.to_s) }
    it { expect(rendered).to match(book_one.cover.url) }

    context 'with short description' do
      before do
        book_one.update(short_description: 'yoyoyo')
        render
      end

      it { expect(rendered).to match('yoyoyo') }
      it { expect(rendered).to have_selector('.short-description') }
    end
  end

  context 'without bestsellers' do
    it 'should show render message' do
      assign(:best_sellers, [])
      render
      expect(rendered).to match(t('home.no_popular'))
    end
  end
end

RSpec.describe 'home/search', type: :view do
  let(:book) { FactoryGirl.create(:book) }
  let(:author) { FactoryGirl.create(:author) }

  before do
    assign(:query, book.to_s)
    assign(:results, [book])
    assign(:search_by, 'books')
  end

  context 'search results' do
    before { render }

    it { expect(rendered).to have_selector('.search-results-query') }
    it { expect(rendered).to have_selector('.search-results-list') }
    it { expect(rendered).to have_selector('.search-results-list li', count: 1) }
  end

  context 'search results for books' do
    before { render }

    it { expect(rendered).to match(book.to_s) }
    it { expect(rendered).to match(book_path(book)) }
  end

  context 'search results for authors' do
    before do
      assign(:query, author.to_s)
      assign(:results, [author])
      assign(:search_by, 'authors')

      render
    end

    it { expect(rendered).to match(author.to_s) }
    it { expect(rendered).to match(author_path(author)) }
  end
end