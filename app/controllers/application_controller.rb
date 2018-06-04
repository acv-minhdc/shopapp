class ApplicationController < ActionController::Base
  before_action :addition_parameter_devise, if: :devise_controller?

  protected

  def addition_parameter_devise
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname])
  end

  private

  def set_cart
    @cart = Cart.find(session[:card_id])
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end

end
