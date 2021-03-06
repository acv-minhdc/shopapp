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
        subprice_of_a_line = cart[a.id.to_s] * a.price
        @total_price += subprice_of_a_line
        item_list[a] = { 'quantity' => cart[a.id.to_s], 'subprice' => subprice_of_a_line }
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

  def add_item?(id, quantity = 1)
    return false if quantity < 1 || Product.find_by(id: id).blank?
    if  session[:cart][id.to_s].present?
      session[:cart][id.to_s] += quantity
    else
      session[:cart][id.to_s] = quantity
    end
    true
  end
end
