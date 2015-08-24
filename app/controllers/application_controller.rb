class ApplicationController < ActionController::Base
  include CurrentOrder

  protect_from_forgery with: :exception

  before_action :set_current_order

  rescue_from CanCan::AccessDenied do |ex|
    if ex.subject == :rails_admin
      not_found
    end

    redirect_to '/', alert: t('auth.access_denied')
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
