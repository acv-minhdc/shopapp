class ApplicationController < ActionController::Base
  before_action :addition_parameter_devise, if: :devise_controller?
  # helper_method :current_cart
  protected

  def addition_parameter_devise
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname])
  end
  
end
