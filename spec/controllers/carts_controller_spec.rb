require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  let(:order) { FactoryGirl.create :order }

  describe '#show' do
    it 'should render :show template' do
      get :show
      expect(response).to render_template('show')
    end
  end

  describe '#complete' do
    context 'with order id in flash' do
      before { allow(Order).to receive(:find).and_return(order) }

      it 'should render :complete template' do
        get :complete, nil, nil, { order_id: order.id }
        expect(response).to render_template 'complete'
      end

      it 'should call #find for Order with flash[:order_id]' do
        expect(Order).to receive(:find).with(order.id)
        get :complete, nil, nil, { order_id: order.id }
      end

      it 'should assign @order, with order' do
        get :complete, nil, nil, { order_id: order.id }
        expect(assigns(:order)).to eq order
      end
    end

    context 'without order id in flash' do
      it { expect { get :complete }.to raise_error(ActionController::RoutingError) }
    end
  end
end
