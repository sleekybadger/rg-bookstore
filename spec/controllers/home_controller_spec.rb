require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:book) { FactoryGirl.create :book }

  describe '#index' do
    before do
      allow(Book).to receive(:best_sellers).and_return([book])
    end

    it 'expect to render :index template' do
      get :index
      expect(response).to render_template('index')
    end

    it 'expect to assigns @best_sellers' do
      get :index
      expect(assigns(:best_sellers)).not_to be_nil
    end

    it 'expect to receive :best_sellers' do
      expect(Book).to receive(:best_sellers)
      get :index
    end
  end

  describe '#search' do
    let(:author) { FactoryGirl.create :author }

    before do
      allow(Book).to receive(:search).with(book.to_s).and_return([book])
      allow(Author).to receive(:search).with(author.to_s).and_return([author])
    end

    it 'expect to render :search template' do
      get :search
      expect(response).to render_template('search')
    end

    it 'expect to assigns @query' do
      get :search, query: 'hello'
      expect(assigns(:query)).not_to be_nil
    end

    it 'expect to assigns @search_by' do
      get :search, search_by: 'hello'
      expect(assigns(:search_by)).not_to be_nil
    end

    it 'expect to assigns @results' do
      get :search, search_by: 'hello'
      expect(assigns(:results)).not_to be_nil
    end

    it 'expect to receive_message_chain :new, :search, :results' do
      expect(Search).to receive_message_chain(:new, :search, :results)
      get :search, search_by: 'hello', query: 'hello'
    end
  end
end
