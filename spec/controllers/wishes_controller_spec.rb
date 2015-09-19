require 'rails_helper'

RSpec.describe WishesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:book) { FactoryGirl.create(:book) }
  let(:wish) { FactoryGirl.create(:wish, user: user, book: book) }
  let(:ability) { create_ability }

  describe '#index' do
    context 'user logged' do
      before { sign_in user }

      it 'expect to assigns @user' do
        get :index, user_id: user.id
        expect(assigns(:user)).not_to be_nil
      end

      it 'expect to assigns @wishes' do
        get :index, user_id: user.id
        expect(assigns(:wishes)).not_to be_nil
      end

      it { expect(get :index, user_id: user.id).to render_template('index') }
    end

    context 'user not logged' do
      it { expect(get :index, user_id: user.id).to redirect_to(new_user_session_path) }
    end

    context 'without abilities' do
      before do
        sign_in user
        ability.cannot :manage, Wish
      end

      it { expect(get :index, user_id: user.id).to redirect_to(root_path) }
    end
  end

  describe '#create' do
    context 'user logged' do
      before do
        sign_in user
        allow(Book).to receive(:find).with(book.id.to_s) { book }
        allow(controller).to receive(:current_user) { user }
        allow(user).to receive_message_chain(:wishes, :new) { wish }
      end

      it 'expect to assigns @book' do
        post :create, book_id: book.id
        expect(assigns(:book)).not_to be_nil
      end

      it 'expect to assigns @wish' do
        post :create, book_id: book.id
        expect(assigns(:wish)).not_to be_nil
      end

      it 'expect to receive :book=' do
        expect(wish).to receive(:book=)
        post :create, book_id: book.id
      end

      it 'expect to receive :save' do
        expect(wish).to receive(:save)
        post :create, book_id: book.id
      end

      it { expect(post :create, book_id: book.id).to redirect_to(book_path(book)) }

      context 'save successfully' do
        it 'expect to fill notice' do
          allow(wish).to receive(:save) { true }
          post :create, book_id: book.id
          expect(flash[:notice]).not_to be_nil
        end
      end

      context 'save unsuccessfully' do
        it 'expect to fill alert' do
          allow(wish).to receive(:save) { false }
          post :create, book_id: book.id
          expect(flash[:alert]).not_to be_nil
        end
      end
    end

    context 'user not logged' do
      it { expect(post :create, book_id: book.id).to redirect_to(new_user_session_path) }
    end

    context 'without user abilities' do
      before do
        sign_in user
        ability.cannot :manage, Wish
      end

      it { expect(post :create, book_id: book.id).to redirect_to(root_path) }
    end
  end

  describe '#destroy' do
    context 'user logged' do
      before do
        sign_in user
        allow(Wish).to receive(:find).with(wish.id.to_s) { wish }
        allow(controller).to receive(:current_user) { user }
        request.env['HTTP_REFERER'] = 'pampam'
      end

      it 'expect to assigns @wish' do
        delete :destroy, id: wish.id
        expect(assigns(:wish)).not_to be_nil
      end

      it 'expect to receive :destroy' do
        expect(wish).to receive(:destroy)
        delete :destroy, id: wish.id
      end

      it { expect(delete :destroy, id: wish.id).to redirect_to('pampam') }

      context 'destroyed successfully' do
        it 'expect to fill notice' do
          allow(wish).to receive(:destroy) { true }
          delete :destroy, id: wish.id
          expect(flash[:notice]).not_to be_nil
        end
      end

      context 'destroyed unsuccessfully' do
        it 'expect to fill alert' do
          allow(wish).to receive(:destroy) { false }
          delete :destroy, id: wish.id
          expect(flash[:alert]).not_to be_nil
        end
      end
    end

    context 'user not logged' do
      it { expect(delete :destroy, id: wish.id).to redirect_to(new_user_session_path) }
    end

    context 'without user abilities' do
      before do
        sign_in user
        ability.cannot :manage, Wish
      end

      it { expect(delete :destroy, id: wish.id).to redirect_to(root_path) }
    end
  end
end
