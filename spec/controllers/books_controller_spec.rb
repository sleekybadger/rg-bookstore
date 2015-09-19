require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:book) { FactoryGirl.create :book }
  let(:ability) { create_ability }

  context 'with cancan abilities' do
    before { ability.can :manage, Book }

    describe '#index' do
      before do
        allow(Category).to receive(:all).and_return([book.category])
        allow(Book).to receive(:page).and_return([book])
      end

      it 'should render :index template' do
        get :index
        expect(response).to render_template 'index'
      end

      it 'should call #page for Book, with :page param' do
        expect(Book).to receive(:page).with('2')
        get :index, page: 2
      end

      it 'should assign @books with books array' do
        get :index
        expect(assigns(:books)).to eq [book]
      end

      it 'should assign @categories with categories array' do
        get :index
        expect(assigns(:categories)).to eq [book.category]
      end
    end

    describe '#show' do
      before do
        allow(Book).to receive(:find).and_return(book)
      end

      it 'should render :show template' do
        get :show, id: book.id
        expect(response).to render_template 'show'
      end

      it 'should call #find for Book, with :id param' do
        expect(Book).to receive(:find).with(book.id.to_s)
        get :show, id: book.id
      end

      it 'should assigns @book with book' do
        get :show, id: book.id
        expect(assigns(:book)).to eq book
      end
    end
  end

  context 'without cancan abilities' do
    before { ability.cannot :manage, Book }

    describe '#index' do
      it 'should redirect to root path' do
        get :index
        expect(response).to redirect_to root_path
      end
    end

    describe '#show' do
      it 'should redirect to root path' do
        get :show, id: book.id
        expect(response).to redirect_to root_path
      end
    end
  end
end
