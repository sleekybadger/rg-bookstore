require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:book) { FactoryGirl.create :book }

  describe '#index' do
    before do
      allow(Book).to receive(:best_sellers).and_return([book])
    end

    it 'should render :index template' do
      get :index
      expect(response).to render_template('index')
    end

    xit 'should assigns @best_sellers with books array' do
      get :index
      expect(assigns(:best_sellers)).to eq [book]
    end
  end

  describe '#search' do
    let(:author) { FactoryGirl.create :author }

    before do
      allow(Book).to receive(:search).with(book.to_s).and_return([book])
      allow(Author).to receive(:search).with(author.to_s).and_return([author])
    end

    it 'should render :search template' do
      get :search
      expect(response).to render_template('search')
    end

    it 'should assigns @query with params[:query]' do
      get :search, query: 'hello'
      expect(assigns(:query)).to eq 'hello'
    end

    it 'should assigns @search_by with params[:search_by]' do
      get :search, search_by: 'hello'
      expect(assigns(:search_by)).to eq 'hello'
    end

    context 'params[:search_by] equal books' do
      it 'should call #search for Book with params[:query]' do
        expect(Book).to receive(:search).with('hello')
        get :search, search_by: 'books', query: 'hello'
      end

      it 'should assigns @results with books array' do
        get :search, search_by: 'books', query: book.to_s
        expect(assigns(:results)).to eq [book]
      end
    end

    context 'params[:search_by] equal authors' do
      it 'should call #search for Author with params[:query]' do
        expect(Author).to receive(:search).with('hello')
        get :search, search_by: 'authors', query: 'hello'
      end

      it 'should assigns @results with authors array' do
        get :search, search_by: 'authors', query: author.to_s
        expect(assigns(:results)).to eq [author]
      end
    end

    context 'other params[:search_by]' do
      it 'should assigns @results with empty array' do
        get :search, search_by: 'yoyoyo'
        expect(assigns(:results)).to eq []
      end
    end
  end
end
