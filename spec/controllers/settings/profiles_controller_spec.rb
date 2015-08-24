require 'rails_helper'

RSpec.describe Settings::ProfilesController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:ability) { create_ability }
  let(:user_info_params) { stringify(FactoryGirl.attributes_for :user) }
  let(:invalid_user_info_params) { stringify(FactoryGirl.attributes_for :user, email: '1231') }
  let(:user_password_params) do
    new_password = Faker::Internet.password

    {
      current_password: Faker::Internet.password,
      password: new_password,
      password_confirmation: new_password
    }
  end
  let(:invalid_user_password_params) do
    {
        current_password: Faker::Internet.password,
        password: Faker::Internet.password,
        password_confirmation: Faker::Internet.password
    }
  end

  before do
    sign_in user
    ability.can :manage, User
    allow(controller).to receive(:current_user) { user }
  end

  describe '#show' do
    context 'with User abilities' do
      it 'should receive :current_user' do
        expect(controller).to receive(:current_user)
        get :show
      end

      it 'should assigns @user' do
        get :show
        expect(assigns(:user)).not_to be_nil
      end

      it { expect(get :show).to render_template('show') }
    end

    context 'without User abilities' do
      before { ability.cannot :manage, User }

      it { expect(get :show).to redirect_to(root_path) }
    end

    context 'user not logged' do
      before { sign_out user }

      it { expect(get :show).to redirect_to(new_user_session_path) }
    end
  end

  describe '#update_info' do
    context 'with valid params' do
      before { allow(user).to receive(:update) { true } }

      it 'should receive :current_user' do
        expect(controller).to receive(:current_user)
        put :update_info, user: user_info_params
      end

      it 'should assigns @user' do
        put :update_info, user: user_info_params
        expect(assigns(:user)).not_to be_nil
      end

      it 'should receive update' do
        expect(user).to receive(:update)
        put :update_info, user: user_info_params
      end

      it { expect(put :update_info, user: user_info_params).to redirect_to(settings_profile_path) }
    end

    context 'with invalid params' do
      before { allow(user).to receive(:update) { false } }

      it { expect(put :update_info, user: invalid_user_info_params).to render_template('show') }
    end

    context 'without User abilities' do
      before { ability.cannot :manage, User }

      it { expect(put :update_info).to redirect_to(root_path) }
    end

    context 'user not logged' do
      before { sign_out user }

      it { expect(put :update_info).to redirect_to(new_user_session_path) }
    end
  end

  describe '#update_password' do
    context 'with valid params' do
      before { allow(user).to receive(:update_with_password) { true } }

      it 'should receive :current_user' do
        expect(controller).to receive(:current_user)
        put :update_password, user: user_password_params
      end

      it 'should assigns @user' do
        put :update_password, user: user_password_params
        expect(assigns(:user)).not_to be_nil
      end

      it 'should receive :update_with_password' do
        expect(user).to receive(:update_with_password)
        put :update_password, user: user_password_params
      end

      it { expect(put :update_password, user: user_password_params).to redirect_to(settings_profile_path) }
    end

    context 'with invalid params' do
      before { allow(user).to receive(:update_with_password) { false } }

      it { expect(put :update_password, user: invalid_user_password_params).to render_template('show') }
    end

    context 'without User abilities' do
      before { ability.cannot :manage, User }

      it { expect(put :update_password).to redirect_to(root_path) }
    end

    context 'user not logged' do
      before { sign_out user }

      it { expect(put :update_password).to redirect_to(new_user_session_path) }
    end
  end

  describe '#destroy' do
    context 'with valid params' do
      before { allow(user).to receive(:destroy) { true } }

      it 'should receive :current_user' do
        expect(controller).to receive(:current_user)
        delete :destroy, want_to_delete: true
      end

      it 'should assigns @user' do
        delete :destroy, want_to_delete: true
        expect(assigns(:user)).not_to be_nil
      end

      it 'should receive :destroy' do
        expect(user).to receive(:destroy)
        delete :destroy, want_to_delete: true
      end
    end

    context 'with invalid params' do
      before { allow(user).to receive(:destroy) { false } }

      it { expect(delete :destroy).to redirect_to(settings_profile_path) }
    end

    context 'destroyed successfully' do
      before { allow(user).to receive(:destroy) { true } }
      it { expect(delete :destroy, want_to_delete: true).to redirect_to(root_path) }
    end

    context 'not destroyed' do
      before { allow(user).to receive(:destroy) { false } }
      it { expect(delete :destroy, want_to_delete: true).to redirect_to(settings_profile_path) }
    end

    context 'without User abilities' do
      before { ability.cannot :manage, User }

      it { expect(delete :destroy).to redirect_to(root_path) }
    end

    context 'user not logged' do
      before { sign_out user }

      it { expect(delete :destroy).to redirect_to(new_user_session_path) }
    end
  end
end
