class Auth::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.present?
      sign_in @user
      redirect_to root_path, notice: t('auth.facebook')
    else
      redirect_to root_path, alert: t('unknown_error')
    end
  end
end