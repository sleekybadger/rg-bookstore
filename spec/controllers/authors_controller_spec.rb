require 'rails_helper'

RSpec.describe AuthorsController, type: :controller do
  let(:author) { FactoryGirl.create :author }
  let(:ability) { create_ability }

  context 'with cancan abilities' do
    before { ability.can :manage, Author }

    describe '#index' do
      before do
        allow(Author).to receive(:page).and_return([author])
      end

      it 'should render :index template' do
        get :index
        expect(response).to render_template 'index'
      end

      it 'should call #page for Author, with :page param' do
        expect(Author).to receive(:page).with('2')
        get :index, page: 2
      end

      it 'should assign @authors with authors array' do
        get :index
        expect(assigns(:authors)).to eq [author]
      end
    end

    describe '#show' do
      before do
        allow(Author).to receive(:find).and_return(author)
      end

      it 'should render :show template' do
        get :show, id: author.id
        expect(response).to render_template :show
      end

      it 'should call #find for Author, with :id param' do
        expect(Author).to receive(:find).with(author.id.to_s)
        get :show, id: author.id
      end

      it 'should assigns @author with author' do
        get :show, id: author.id
        expect(assigns(:author)).to eq author
      end
    end
  end

  context 'without cancan abilities' do
    before { ability.cannot :manage, Author }

    describe '#index' do
      it 'should redirect to root path' do
        get :index
        expect(response).to redirect_to root_path
      end
    end

    describe '#show' do
      it 'should redirect to root path' do
        get :show, id: author.id
        expect(response).to redirect_to root_path
      end
    end
  end
end
