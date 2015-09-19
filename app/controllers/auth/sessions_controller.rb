class Auth::SessionsController < Devise::SessionsController

  protected

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  private

  def respond_to_on_destroy
    respond_to do |format|
      format.all { redirect_to after_sign_out_path_for(resource_name) }
    end
  end
end