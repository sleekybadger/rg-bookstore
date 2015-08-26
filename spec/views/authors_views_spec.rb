require 'rails_helper'

RSpec.describe 'authors/index', type: :view do
  context 'with authors' do
    let(:author) { FactoryGirl.create :author }
    let(:authors) { Kaminari.paginate_array([author]).page(1) }

    before do
      assign(:authors, authors)
      render
    end

    it { expect(rendered).to match('.authors-list') }
    it { expect(rendered).to match(author.to_s) }
    it { expect(rendered).to match(author.portrait.thumb.url) }
  end

  context 'without authors' do
    it 'should show empty message' do
      render
      expect(rendered).to match('.authors-empty')
    end
  end
end

RSpec.describe 'authors/show', type: :view do
  let(:author) { FactoryGirl.create :author }

  before { assign(:author, author) }

  context 'required info' do
    before { render }

    it { expect(rendered).to match(author.to_s) }
    it { expect(rendered).to match(author.portrait.url) }
  end

  context 'with bio' do
    it 'should show author bio' do
      author.update(biography: 'Hello baby')
      render
      expect(rendered).to match(author.biography)
    end
  end

  context 'author has books' do
    let!(:book) { FactoryGirl.create :book, author: author }

    before { render }

    it { expect(rendered).to match('.author-books-list') }
    it { expect(rendered).to match(book.to_s) }
  end

  context 'author without books' do
    it 'should show empty message' do
      render
      expect(rendered).to match('.author-no-books')
    end
  end
end