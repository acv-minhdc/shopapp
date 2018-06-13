class ApplicationController < ActionController::Base
  before_action :addition_parameter_devise, if: :devise_controller?
  # helper_method :current_cart

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

  protected

  def addition_parameter_devise
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname])
  end

end
