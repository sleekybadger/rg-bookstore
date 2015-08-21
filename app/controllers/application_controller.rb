class ApplicationController < ActionController::Base

  include CurrentOrder

  protect_from_forgery with: :exception

  before_action :set_current_order

  rescue_from CanCan::AccessDenied do |ex|
    if ex.subject == :rails_admin
      not_found
    end

    if user_signed_in?
      redirect_to '/', alert: t('auth.access_denied')
    else
      redirect_to new_user_session_path, alert: t('auth.sign_in_first')
    end

  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
