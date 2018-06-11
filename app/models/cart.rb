class Cart < ApplicationRecord
  has_many :cart_items
  belongs_to :user, optional: true

  def merge_to_session_cart
    items = CartItem.where(cart: self).pluck(:product_id, :quantity).to_h.stringify_keys!
    mutual_keys = []
    session[:cart].merge!(items) { |key, oldval, newval| oldval + newval }
    session[:cart].each do |product_id, quantity|
      cart_items.where()
    end
  end
end
