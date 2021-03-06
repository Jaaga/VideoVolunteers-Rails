class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!
  layout :layout_by_controller

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected


  def layout_by_controller
    devise_controller? ? 'devise' : 'application'
  end


  private

  def after_sign_in_path_for(resource)
    home_path
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :name
  end
end
