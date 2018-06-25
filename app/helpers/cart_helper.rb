module CartHelper
  def get_items_cart
    cart = session[:cart]
    item_list = {}
    if cart.present?
      # Get products from DB
      products = Product.find(cart.keys)
      # Create quantity array
      @total_price = 0
      products.each do |a|
        item_list[a] = {}
        cart[a.id.to_s].each do |product_attr, quantity|
          subprice_of_a_line = quantity * a.price
          @total_price += subprice_of_a_line
          item_list[a][product_attr] = { 'quantity' => quantity, 'subprice' => subprice_of_a_line }
        end
      end
    end
    item_list
  end

  def merge_to_session_cart
    session[:cart] ||= {}
    session[:cart].merge!(JSON.parse(current_user.cart.items)) { |_key, oldval, newval| oldval + newval } if current_user.cart.items.present?
    current_user.cart.items = JSON(session[:cart])
    current_user.cart.save!
  end

  def empty_cart
    session[:cart] = {}
    sync_cart
  end

  def sync_cart
    if user_signed_in?
      current_user.cart.items = JSON(session[:cart]) if session[:cart]
      current_user.cart.save!
    end
  end

  def add_item?(id, quantity = 1, product_attr = nil)
    product = Product.find_by(id: id)
    return false if quantity < 1 || product.blank?
    product_attr = { 'color' => product.colors.first, 'size' => 'M' }.to_s if product_attr.blank?
    if  session[:cart][id.to_s].present? && session[:cart][id.to_s][product_attr].present?
      session[:cart][id.to_s][product_attr] += quantity
    elsif session[:cart][id.to_s].present?
      session[:cart][id.to_s][product_attr] = quantity
    else
      session[:cart][id.to_s] = { product_attr => quantity }
    end
    true
  end
end
