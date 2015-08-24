require 'rails_helper'

RSpec.describe CheckoutController, type: :controller do
  let(:order_with_items) { FactoryGirl.create :order_with_items }
  let(:order_without_items) { FactoryGirl.create :order }
  let(:bill_params) { stringify(FactoryGirl.attributes_for :billing_address) }
  let(:ship_params) { stringify(FactoryGirl.attributes_for :shipping_address) }
  let(:delivery_id) { FactoryGirl.create(:delivery).id }
  let(:card_params) { stringify(FactoryGirl.attributes_for :credit_card) }
  let(:invalid_card_params) { stringify(FactoryGirl.attributes_for :credit_card, number: 'asd') }

  before do
    allow(controller).to receive(:current_order) { order_with_items }
  end

  describe '#show' do
    it 'should assigns @user' do
      get :show, id: 'address'
      expect(assigns(:user)).not_to be_nil
    end

    context 'address' do
      it { expect(get :show, id: 'address').to render_template('address') }

      it 'should assigns @countries' do
        get :show, id: 'address'
        expect(assigns(:countries)).not_to be_nil
      end

      context 'order without billing address' do
        it 'should receive :build_billing_address' do
          order_with_items.billing_address = nil
          expect(order_with_items).to receive(:build_billing_address)
          get :show, id: 'address'
        end
      end

      context 'order without shipping address' do
        it 'should receive :build_shipping_address' do
          order_with_items.shipping_address = nil
          expect(order_with_items).to receive(:build_shipping_address)
          get :show, id: 'address'
        end
      end
    end

    context 'delivery' do
      it { expect(get :show, id: 'delivery').to render_template('delivery') }

      it 'should assigns @deliveries' do
        get :show, id: 'delivery'
        expect(assigns(:deliveries)).not_to be_nil
      end
    end

    context 'payment' do
      it { expect(get :show, id: 'payment').to render_template('payment') }

      context 'order without credit card' do
        it 'should receive :build_credit_card' do
          order_with_items.credit_card = nil
          expect(order_with_items).to receive(:build_credit_card)
          get :show, id: 'payment'
        end
      end
    end

    context 'confirm' do
      it { expect(get :show, id: 'confirm').to render_template('confirm') }

      it 'should redirect to :address if order without billing or shipping' do
        order_with_items.billing_address = nil
        order_with_items.shipping_address = nil

        expect(get :show, id: 'confirm').to redirect_to cart_checkout_path :address
      end

      it 'should redirect to :delivery if order without delivery' do
        order_with_items.delivery = nil

        expect(get :show, id: 'confirm').to redirect_to cart_checkout_path :delivery
      end

      it 'should redirect to :payment if order without credit_card' do
        order_with_items.credit_card = nil

        expect(get :show, id: 'confirm').to redirect_to cart_checkout_path :payment
      end
    end

    context 'wicked_finish' do
      it { expect(get :show, id: 'wicked_finish').to redirect_to complete_cart_path }
    end

    context 'without card items' do
      before { allow(controller).to receive(:current_order) { order_without_items } }
      it { expect { get :show, id: 'address' }.to raise_error(ActionController::RoutingError) }
    end
  end

  describe '#update' do
    it 'should assigns @user' do
      put :update, id: 'address', order: {billing_address_attributes: bill_params, shipping_address_attributes: ship_params}
      expect(assigns(:user)).not_to be_nil
    end

    context 'address' do
      it 'should assigns @countries' do
        put :update, id: 'address', order: {billing_address_attributes: bill_params, shipping_address_attributes: ship_params}
        expect(assigns(:countries)).not_to be_nil
      end

      it 'should redirect to delivery when saved successfully' do
        allow(order_with_items).to receive(:save) { true }
        put :update, id: 'address', order: {billing_address_attributes: bill_params, shipping_address_attributes: ship_params}
        expect(response).to redirect_to cart_checkout_path :delivery
      end

      it 'should render :address when not saved' do
        put :update, id: 'address', order: {billing_address_attributes: {}, shipping_address_attributes: {}}
        expect(response).to render_template('address')
      end
    end

    context 'delivery' do
      it 'should assigns @deliveries' do
        put :update, id: 'delivery', order: { delivery_id: delivery_id }
        expect(assigns(:deliveries)).not_to be_nil
      end

      it 'should redirect to payment when saved successfully' do
        allow(order_with_items).to receive(:save) { true }
        put :update, id: 'delivery', order: { delivery_id: delivery_id }
        expect(response).to redirect_to cart_checkout_path :payment
      end

      it 'should render :delivery when not saved' do
        allow(order_with_items).to receive(:save) { false }
        put :update, id: 'delivery', order: { delivery_id: nil }
        expect(response).to render_template('delivery')
      end
    end

    context 'payment' do
      it 'should redirect to confirm when saved successfully' do
        allow(order_with_items).to receive(:save) { true }
        put :update, id: 'payment', order: { credit_card_attributes: card_params }
        expect(response).to redirect_to cart_checkout_path :confirm
      end

      it 'should render :payment when not saved' do
        allow(order_with_items).to receive(:save) { false }
        put :update, id: 'payment', order: { credit_card_attributes: card_params }
        expect(response).to render_template('payment')
      end
    end

    context 'confirm' do
      it 'should receive :place_order!' do
        expect(order_with_items).to receive(:place_order!)
        put :update, id: 'confirm'
      end

      it 'should redirect to cart_checkout_path :confirm' do
        allow(order_with_items).to receive(:in_queue?) { false }
        put :update, id: 'confirm'
        expect(response).to redirect_to cart_checkout_path :confirm
      end

      it 'should receive :user=' do
        expect(order_with_items).to receive(:user=)
        put :update, id: 'confirm'
      end

      it { expect(put :update, id: 'confirm').to redirect_to cart_checkout_path :wicked_finish }
    end

    context 'without card items' do
      before { allow(controller).to receive(:current_order) { order_without_items } }
      it { expect { put :show, id: 'address' }.to raise_error(ActionController::RoutingError) }
    end
  end
end
