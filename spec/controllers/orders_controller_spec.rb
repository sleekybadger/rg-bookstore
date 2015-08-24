require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:book) { FactoryGirl.create :book }
  let(:order) { FactoryGirl.create :order }
  let(:order_item) { FactoryGirl.create :order_item, book: book }
  let(:order_item_params) { stringify(FactoryGirl.attributes_for(:order_item)) }

  before do
    allow(Book).to receive(:find).and_return(book)
    allow(controller).to receive(:current_order).and_return(order)
  end

  describe '#add_item with valid attributes' do
    it 'should call #find for Book with params[:book_id]' do
      expect(Book).to receive(:find).with(book.id.to_s)
      post :add_item, book_id: book.id, order_item: order_item_params
    end

    it 'should assigns @book with book' do
      post :add_item, book_id: book.id, order_item: order_item_params
      expect(assigns(:book)).to eq book
    end

    context 'current_order dont have order_item with book' do
      before do
        allow(controller).to receive_message_chain(
          :current_order,
          :order_items,
          :find_by
        )
      end

      it 'should call new for OrderItem with order_item_params' do
        expect(OrderItem).to receive(:new).with(order_item_params).and_call_original
        post :add_item, book_id: book.id, order_item: order_item_params
      end

      it 'should create new order_item' do
        old_count = OrderItem.count

        post :add_item, book_id: book.id, order_item: order_item_params

        expect(OrderItem.count).to eq(old_count + 1)
      end

      it 'should set book for new OrderItem' do
        post :add_item, book_id: book.id, order_item: order_item_params
        expect(OrderItem.last.book).to eq(book)
      end

      it 'should set order for new OrderItem' do
        post :add_item, book_id: book.id, order_item: order_item_params
        expect(OrderItem.last.order).to eq(order)
      end
    end

    context 'current_order have order_item with book' do
      before do
        allow(controller).to receive_message_chain(
          :current_order,
          :order_items,
          :find_by
        ) { order_item }
      end

      it 'should increment quantity for order_item' do
        result = order_item.quantity + order_item_params['quantity'].to_i

        post :add_item, book_id: book.id, order_item: order_item_params

        expect(order_item.quantity).to eq(result)
      end
    end

    it 'should redirect to book' do
      post :add_item, book_id: book.id, order_item: order_item_params
      expect(response).to redirect_to(book_path(book))
    end
  end

  describe '#add_item with invalid attributes' do
    it { expect { post :add_item, book_id: book.id }.to raise_error(ActionController::ParameterMissing) }
  end

  describe '#remove_item with valid attributes' do
    before do
      allow(controller).to receive_message_chain(
        :current_order,
        :order_items,
        :find_by
      ) { order_item }
    end

    it 'should call #find for Book with params[:book_id]' do
      expect(Book).to receive(:find).with(book.id.to_s)
      post :remove_item, book_id: book.id, order_item: order_item_params
    end

    it 'should assigns @book with book_path' do
      post :remove_item, book_id: book.id, order_item: order_item_params
      expect(assigns(:book)).to eq book
    end

    it 'should call #reduce_quantity for order_item' do
      expect(order_item).to receive(:reduce_quantity).with(order_item_params['quantity']).and_call_original
      post :remove_item, book_id: book.id, order_item: order_item_params
    end

    it 'should redirect to cart_path' do
      post :remove_item, book_id: book.id, order_item: order_item_params
      expect(response).to redirect_to(cart_path)
    end
  end

  describe '#remove_item with invalid attributes' do
    it { expect { post :remove_item, book_id: book.id }.to raise_error(ActionController::ParameterMissing) }
  end
end
