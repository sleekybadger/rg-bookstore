class Settings::ProfilesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_user

  authorize_resource :user

  def show
  end

  def update_info
    respond_to do |format|
      if @user.update(user_info_params)
        format.html { redirect_to settings_profile_path, notice: t('profile.info_updated') }
      else
        format.html { render :show }
      end
    end
  end

  def update_password
    respond_to do |format|
      if @user.update_with_password(user_password_params)
        sign_in @user, bypass: true
        format.html { redirect_to settings_profile_path, notice: t('profile.password_updated') }
      else
        format.html { render :show }
      end
    end
  end

  def destroy
    respond_to do |format|
      unless params[:want_to_delete]
        format.html { redirect_to settings_profile_path, alert: t('profile.destroy_need_confirm') }
      else
        if @user.destroy
          sign_out
          format.html { redirect_to root_path, notice: t('profile.destroyed') }
        else
          format.html { redirect_to settings_profile_path, alert: t('unknown_error') }
        end
      end
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_info_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end

  def user_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end