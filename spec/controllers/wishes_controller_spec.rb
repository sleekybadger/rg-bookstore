require 'rails_helper'

RSpec.describe WishesController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:book) { FactoryGirl.create :book }
  let(:ability) { create_ability }

  describe '#index' do
    context 'user logged' do
      before { sign_in user }

      it 'should assigns @user' do
        get :index, user_id: user.id
        expect(assigns(:user)).not_to be_nil
      end

      it { expect(get :index, user_id: user.id).to render_template('index') }
    end

    context 'user not logged' do
      it { expect(get :index, user_id: user.id).to redirect_to(new_user_session_path) }
    end

    context 'without user abilities' do
      before do
        sign_in user
        ability.cannot :manage, User
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
        allow(user).to receive_message_chain(:wishes, :exists?).with(book) { true }
      end

      it 'should assigns @user' do
        get :index, user_id: user.id
        expect(assigns(:user)).not_to be_nil
      end

      it 'should receive find for Book and return book' do
        expect(Book).to receive(:find).with(book.id.to_s)
        post :create, book_id: book.id
      end

      it 'should assigns @book' do
        post :create, book_id: book.id
        expect(assigns(:book)).not_to be_nil
      end

      context 'user has book in wishes' do
        it 'should not receive << for user wishes' do
          expect(user.wishes).not_to receive(:<<)
          post :create, book_id: book.id
        end
      end

      context 'user has not book in wishes' do
        it 'should receive << for user wishes' do
          allow(user).to receive_message_chain(:wishes, :exists?).with(book) { false }
          expect(user.wishes).to receive(:<<)
          post :create, book_id: book.id
        end
      end

      it { expect(post :create, book_id: book.id).to redirect_to(user_wishes_path(user)) }
    end

    context 'user not logged' do
      it { expect(post :create, book_id: book.id).to redirect_to(new_user_session_path) }
    end

    context 'without user abilities' do
      before do
        sign_in user
        ability.cannot :manage, User
      end

      it { expect(post :create, book_id: book.id).to redirect_to(root_path) }
    end
  end

  describe '#destroy' do
    context 'user logged' do
      before do
        sign_in user
        allow(Book).to receive(:find).with(book.id.to_s) { book }
        allow(controller).to receive(:current_user) { user }
        allow(user).to receive_message_chain(:wishes, :exists?).with(book) { false }
      end

      it 'should assigns @user' do
        delete :destroy, book_id: book.id
        expect(assigns(:user)).not_to be_nil
      end

      it 'should receive find for Book and return book' do
        expect(Book).to receive(:find).with(book.id.to_s)
        delete :destroy, book_id: book.id
      end

      it 'should assigns @book' do
        delete :destroy, book_id: book.id
        expect(assigns(:book)).not_to be_nil
      end

      context 'user has book in wishes' do
        it 'should not receive delete for user wishes' do
          expect(user.wishes).not_to receive(:delete)
          delete :destroy, book_id: book.id
        end
      end

      context 'user has not book in wishes' do
        it 'should receive delete for user wishes' do
          allow(user).to receive_message_chain(:wishes, :exists?).with(book) { true }
          expect(user.wishes).to receive(:delete)
          delete :destroy, book_id: book.id
        end
      end

      it { expect(delete :destroy, book_id: book.id).to redirect_to(user_wishes_path(user)) }
    end

    context 'user not logged' do
      it { expect(delete :destroy, book_id: book.id).to redirect_to(new_user_session_path) }
    end

    context 'without user abilities' do
      before do
        sign_in user
        ability.cannot :manage, User
      end

      it { expect(delete :destroy, book_id: book.id).to redirect_to(root_path) }
    end
  end
end
