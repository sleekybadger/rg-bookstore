require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:book) { FactoryGirl.create :book }
  let(:user) { FactoryGirl.create :user }
  let(:review) { FactoryGirl.create :review }
  let(:review_params) { stringify(FactoryGirl.attributes_for(:review)) }
  let(:invalid_review_params) { FactoryGirl.attributes_for :review, note: '' }

  context 'user logged' do
    before do
      sign_in user

      allow(Book).to receive(:find).with(book.id.to_s) { book }
    end

    describe '#new' do
      context 'user already left review for book' do
        before { review.update(book: book, user: user) }

        it 'should redirect to root_path' do
          get :new, book_id: book.id
          expect(response).to redirect_to(root_path)
        end
      end

      context 'user do not leave review for book' do
        it 'should render template :new' do
          get :new, book_id: book.id
          expect(response).to render_template('new')
        end

        it 'should assigns @book with book' do
          get :new, book_id: book.id
          expect(assigns(:book)).to eq book
        end

        it 'should assign @review with new Review' do
          new_review = Review.new
          allow(Review).to receive(:new) { new_review }

          get :new, book_id: book.id

          expect(assigns(:review)).to eq new_review
        end
      end
    end

    describe '#index' do
      before { allow(book).to receive_message_chain(:reviews, :approved, :page) { [review] } }

      it 'should render template :index' do
        get :index, book_id: book.id
        expect(response).to render_template('index')
      end

      it 'should assigns @book with book' do
        get :index, book_id: book.id
        expect(assigns(:book)).to eq book
      end

      it 'should assigns @reviews with reviews array' do
        get :index, book_id: book.id
        expect(assigns(:reviews)).to eq [review]
      end
    end

    describe '#create' do
      context 'with valid params' do
        before { allow_any_instance_of(Review).to receive(:save) { true } }

        it 'should assigns @book with book' do
          post :create, book_id: book.id, review: review_params
          expect(assigns(:book)).to eq book
        end

        it 'should assigns @review' do
          post :create, book_id: book.id, review: review_params
          expect(assigns(:review)).not_to be_nil
        end

        it 'receives :new for Review' do
          expect(Review).to receive(:new).with(review_params).and_call_original
          post :create, book_id: book.id, review: review_params
        end

        it 'should redirect to book' do
          post :create, book_id: book.id, review: review_params
          expect(response).to redirect_to(book_path(book))
        end
      end

      context 'user already left review for book' do
        before { review.update(book: book, user: user) }

        it 'should redirect to root_path' do
          post :create, book_id: book.id, review: review_params
          expect(response).to redirect_to(root_path)
        end
      end

      context 'with invalid params' do
        it 'should render :new template' do
          post :create, book_id: book.id, review: invalid_review_params
          expect(response).to render_template('new')
        end
      end
    end
  end

  context 'user not logged' do
    before { sign_out user }

    describe '#new' do
      it 'should redirect to new_user_session_path' do
        get :new, book_id: book.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe '#index' do
      it 'should not redirect to new_user_session_path' do
        get :index, book_id: book.id
        expect(response).not_to redirect_to(new_user_session_path)
      end
    end

    describe '#create' do
      it 'should redirect to new_user_session_path' do
        post :create, book_id: book.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
