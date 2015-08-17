class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include CurrentOrder

  before_action :set_current_order

  rescue_from CanCan::AccessDenied do
    if user_signed_in?
      redirect_to root_url, alert: t('auth.access_denied')
    else
      redirect_to new_user_session_url, alert: t('auth.sign_in_first')
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
