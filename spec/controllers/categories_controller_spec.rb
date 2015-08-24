require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:category) { FactoryGirl.create :category }
  let(:book) { FactoryGirl.create :book, category: category }
  let(:ability) { create_ability }

  context 'with cancan abilities' do
    before do
      ability.can :manage, Category

      allow(Category).to receive(:find).and_return(category)
      allow(Category).to receive(:all).and_return([category])
      allow(category).to receive_message_chain(:books, :page) { [book] }
    end

    describe '#show' do
      it 'should render :show template' do
        get :show, id: category.id
        expect(response).to render_template 'show'
      end

      it 'should call #find for category with :id param' do
        expect(Category).to receive(:find).with(category.id.to_s)
        get :show, id: category.id
      end

      it 'should assign @category with category' do
        get :show, id: category.id
        expect(assigns(:category)).to eq category
      end

      it 'should assign @categories, with categories array' do
        get :show, id: category.id
        expect(assigns(:categories)).to eq [category]
      end

      it 'should call #page with :page param for category.books' do
        expect(category.books).to receive(:page).with('2')
        get :show, id: category.id, page: 2
      end

      it 'should assign @books, with books array' do
        get :show, id: category.id
        expect(assigns(:books)).to eq [book]
      end
    end
  end

  context 'without cancan abilities' do
    before { ability.cannot :manage, Category }

    describe '#show' do
      it 'should redirect to root path' do
        get :show, id: category.id
        expect(response).to redirect_to root_path
      end
    end
  end
end
