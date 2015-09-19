require 'rails_helper'

RSpec.describe Settings::ShippingAddressesController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:address) { FactoryGirl.create :shipping_address }
  let(:ability) { create_ability }
  let(:address_params) { stringify(FactoryGirl.attributes_for :shipping_address) }
  let(:invalid_address_params) { stringify(FactoryGirl.attributes_for :shipping_address, first_name: nil) }

  describe '#show' do
    context 'with abilities' do
      before do
        sign_in user
        ability.can :manage, Shopper::ShippingAddress
      end

      it { expect(get :show).to render_template('show') }

      it 'should assigns @shipping_address' do
        get :show
        expect(assigns(:shipping_address)).not_to be_nil
      end
    end

    context 'without abilities' do
      before do
        sign_in user
        ability.cannot :manage, Shopper::ShippingAddress
      end

      it { expect(get :show).to redirect_to(root_path) }
    end

    context 'user not logged' do
      it { expect(get :show).to redirect_to(new_user_session_path) }
    end
  end

  describe '#create' do
    context 'with valid attributes' do
      before do
        sign_in user
        ability.can :manage, Shopper::ShippingAddress
        allow(controller).to receive(:current_user) { user }
        allow(user).to receive(:build_shipping_address).with(address_params) { address }
        allow(address).to receive(:save) { true }
      end

      it 'should assigns @shipping_address' do
        post :create, shipping_address: address_params
        expect(assigns(:shipping_address)).not_to be_nil
      end

      it 'should receive build_shipping_address for user with address_params' do
        expect(user).to receive(:build_shipping_address).with(address_params)
        post :create, shipping_address: address_params
      end

      it { expect(post :create, shipping_address: address_params).to redirect_to(settings_shipping_address_path) }
    end

    context 'with invalid attributes' do
      before do
        sign_in user
        ability.can :manage, Shopper::ShippingAddress
        allow(controller).to receive(:current_user) { user }
        allow(user).to receive(:build_shipping_address).with(invalid_address_params) { address }
        allow(address).to receive(:save) { false }
      end

      it { expect(post :create, shipping_address: invalid_address_params).to render_template('show') }
    end

    context 'without abilities' do
      before do
        sign_in user
        ability.cannot :manage, Shopper::ShippingAddress
      end

      it { expect(post :create, shipping_address: address_params).to redirect_to(root_path) }
    end

    context 'user not logged' do
      it { expect(post :create, shipping_address: address_params).to redirect_to(new_user_session_path) }
    end
  end

  describe '#update' do
    context 'with valid attributes' do
      before do
        sign_in user
        ability.can :manage, Shopper::ShippingAddress
        allow(controller).to receive(:current_user) { user }
        allow(user).to receive(:shipping_address) { address }
        allow(address).to receive(:update) { true }
      end

      it 'should assigns @shipping_address' do
        put :update, shipping_address: address_params
        expect(assigns(:shipping_address)).not_to be_nil
      end

      it 'should receive shipping_address for user' do
        expect(user).to receive(:shipping_address)
        put :update, shipping_address: address_params
      end

      it { expect(put :update, shipping_address: address_params).to redirect_to(settings_shipping_address_path) }
    end

    context 'with invalid attributes' do
      before do
        sign_in user
        ability.can :manage, Shopper::ShippingAddress
        allow(controller).to receive(:current_user) { user }
        allow(user).to receive(:shipping_address) { address }
        allow(address).to receive(:update) { false }
      end

      it { expect(put :update, shipping_address: invalid_address_params).to render_template('show') }
    end

    context 'without abilities' do
      before do
        sign_in user
        ability.cannot :manage, Shopper::ShippingAddress
      end

      it { expect(put :update, shipping_address: address_params).to redirect_to(root_path) }
    end

    context 'user not logged' do
      it { expect(put :update, shipping_address: address_params).to redirect_to(new_user_session_path) }
    end
  end

  describe '#destroy' do
    context 'with abilities' do
      before do
        sign_in user
        ability.can :manage, Shopper::ShippingAddress
        allow(controller).to receive(:current_user) { user }
        allow(user).to receive(:shipping_address) { address }
        allow(address).to receive(:destroy) { true }
      end

      it 'should assigns @shipping_address' do
        delete :destroy
        expect(assigns(:shipping_address)).not_to be_nil
      end

      it 'should receive shipping_address for user' do
        expect(user).to receive(:shipping_address)
        delete :destroy
      end

      it { expect(delete :destroy).to redirect_to(settings_shipping_address_path) }
    end

    context 'without abilities' do
      before do
        sign_in user
        ability.cannot :manage, Shopper::ShippingAddress
      end

      it { expect(delete :destroy).to redirect_to(root_path) }
    end

    context 'user not logged' do
      it { expect(delete :destroy).to redirect_to(new_user_session_path) }
    end
  end
end
