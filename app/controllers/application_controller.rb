class ApplicationController < ActionController::Base
  before_action :addition_parameter_devise, if: :devise_controller?
  # helper_method :current_cart
  helper_method :cart_session

  def cart_session
    session[:cart] ||= {}
  end

  protected

  def addition_parameter_devise
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname])
  end

  private

  def current_cart
    cart = Cart.find(session[:card_id])
    return cart if !cart.nil?
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end
end
