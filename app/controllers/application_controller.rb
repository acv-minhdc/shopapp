class ApplicationController < ActionController::Base
  # before_action :addition_parameter_devise, if: :devise_controller?
  helper_method :current_cart

  protected

  def get_items_cart
    cart = session[:cart]
    item_list = {}
    if cart.present?
      # Get products from DB
      products = Product.find(cart.keys.map(&:to_s))
      # Create quantity array
      products.each do |a|
        item_list[a] = { 'quantity' => cart[a.id.to_s] }
      end
    end
    item_list
  end

  def merge_to_session_cart
    session[:cart] ||= {}
    items = JSON.parse(current_user.cart.items)
    session[:cart].merge!(items) { |key, oldval, newval| oldval + newval }
    current_user.cart.items = JSON(session[:cart])
    current_user.cart.save!
  end


  # def addition_parameter_devise
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname])
  # end

end
