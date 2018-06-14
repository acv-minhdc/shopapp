class ApplicationController < ActionController::Base
  # before_action :addition_parameter_devise, if: :devise_controller?

  protected

  def get_items_cart
    cart = session[:cart]
    item_list = {}
    if cart.present?
      # Get products from DB
      products = Product.find(cart.keys.map(&:to_s))
      # Create quantity array
      @total_price = 0
      products.each do |a|
        subprice_of_a_line = cart[a.id.to_s]*a.price
        @total_price += subprice_of_a_line
        item_list[a] = { 'quantity' => cart[a.id.to_s], 'subprice' => subprice_of_a_line }
      end
    end
    item_list
  end

  def merge_to_session_cart
    session[:cart] ||= {}
    session[:cart].merge!(JSON.parse(current_user.cart.items)) { |key, oldval, newval| oldval + newval } if current_user.cart.items.present?
    current_user.cart.items = JSON(session[:cart])
    current_user.cart.save!
  end

  def empty_cart
    session[:cart] = {}
    current_user.cart.empty_cart if user_signed_in?
  end


  # def addition_parameter_devise
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname])
  # end

end
