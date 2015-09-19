class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |ex|
    if ex.subject == :rails_admin
      not_found
    end

    redirect_to '/', alert: t('auth.access_denied')
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def redirect_to_back_or_root(*args)
    if request.env['HTTP_REFERER'].present? && request.env['HTTP_REFERER'] != request.env['REQUEST_URI']
      redirect_to :back, *args
    else
      redirect_to root_path, *args
    end
  end
end
