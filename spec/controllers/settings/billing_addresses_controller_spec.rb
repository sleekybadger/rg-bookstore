require 'rails_helper'

RSpec.describe Settings::BillingAddressesController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:address) { FactoryGirl.create :billing_address }
  let(:ability) { create_ability }
  let(:address_params) { stringify(FactoryGirl.attributes_for :billing_address) }
  let(:invalid_address_params) { stringify(FactoryGirl.attributes_for :billing_address, first_name: nil) }

  describe '#show' do
    context 'with abilities' do
      before do
        sign_in user
        ability.can :manage, Shopper::BillingAddress
      end

      it { expect(get :show).to render_template('show') }

      it 'should assigns @billing_address' do
        get :show
        expect(assigns(:billing_address)).not_to be_nil
      end
    end

    context 'without abilities' do
      before do
        sign_in user
        ability.cannot :manage, Shopper::BillingAddress
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
        ability.can :manage, Shopper::BillingAddress
        allow(controller).to receive(:current_user) { user }
        allow(user).to receive(:build_billing_address).with(address_params) { address }
        allow(address).to receive(:save) { true }
      end

      it 'should assigns @billing_address' do
        post :create, billing_address: address_params
        expect(assigns(:billing_address)).not_to be_nil
      end

      it 'should receive build_billing_address for user with address_params' do
        expect(user).to receive(:build_billing_address).with(address_params)
        post :create, billing_address: address_params
      end

      it { expect(post :create, billing_address: address_params).to redirect_to(settings_billing_address_path) }
    end

    context 'with invalid attributes' do
      before do
        sign_in user
        ability.can :manage, Shopper::BillingAddress
        allow(controller).to receive(:current_user) { user }
        allow(user).to receive(:build_billing_address).with(invalid_address_params) { address }
        allow(address).to receive(:save) { false }
      end

      it { expect(post :create, billing_address: invalid_address_params).to render_template('show') }
    end

    context 'without abilities' do
      before do
        sign_in user
        ability.cannot :manage, Shopper::BillingAddress
      end

      it { expect(post :create, billing_address: address_params).to redirect_to(root_path) }
    end

    context 'user not logged' do
      it { expect(post :create, billing_address: address_params).to redirect_to(new_user_session_path) }
    end
  end

  describe '#update' do
    context 'with valid attributes' do
      before do
        sign_in user
        ability.can :manage, Shopper::BillingAddress
        allow(controller).to receive(:current_user) { user }
        allow(user).to receive(:billing_address) { address }
        allow(address).to receive(:update) { true }
      end

      it 'should assigns @billing_address' do
        put :update, billing_address: address_params
        expect(assigns(:billing_address)).not_to be_nil
      end

      it 'should receive billing_address for user' do
        expect(user).to receive(:billing_address)
        put :update, billing_address: address_params
      end

      it { expect(put :update, billing_address: address_params).to redirect_to(settings_billing_address_path) }
    end

    context 'with invalid attributes' do
      before do
        sign_in user
        ability.can :manage, Shopper::BillingAddress
        allow(controller).to receive(:current_user) { user }
        allow(user).to receive(:billing_address) { address }
        allow(address).to receive(:update) { false }
      end

      it { expect(put :update, billing_address: invalid_address_params).to render_template('show') }
    end

    context 'without abilities' do
      before do
        sign_in user
        ability.cannot :manage, Shopper::BillingAddress
      end

      it { expect(put :update, billing_address: address_params).to redirect_to(root_path) }
    end

    context 'user not logged' do
      it { expect(put :update, billing_address: address_params).to redirect_to(new_user_session_path) }
    end
  end

  describe '#destroy' do
    context 'with abilities' do
      before do
        sign_in user
        ability.can :manage, Shopper::BillingAddress
        allow(controller).to receive(:current_user) { user }
        allow(user).to receive(:billing_address) { address }
        allow(address).to receive(:destroy) { true }
      end

      it 'should assigns @billing_address' do
        delete :destroy
        expect(assigns(:billing_address)).not_to be_nil
      end

      it 'should receive billing_address for user' do
        expect(user).to receive(:billing_address)
        delete :destroy
      end

      it { expect(delete :destroy).to redirect_to(settings_billing_address_path) }
    end

    context 'without abilities' do
      before do
        sign_in user
        ability.cannot :manage, Shopper::BillingAddress
      end

      it { expect(delete :destroy).to redirect_to(root_path) }
    end

    context 'user not logged' do
      it { expect(delete :destroy).to redirect_to(new_user_session_path) }
    end
  end
end
