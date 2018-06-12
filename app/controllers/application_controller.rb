class ApplicationController < ActionController::Base
  # before_action :addition_parameter_devise, if: :devise_controller?
  helper_method :current_cart

  protected

  def get_items_cart
    session[:cart] ||= {}
    products = session[:cart]
    line_items = {}
    if products.present?
      # Get products from DB
      products_array = Product.find(products.keys.map(&:to_s))
      # Create Qty Array
      products_array.each do |a|
        line_items[a] = { 'quantity' => products[a.id.to_s] }
      end
    end
    line_items
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
