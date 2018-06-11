class Cart < ApplicationRecord
  has_many :cart_items
  belongs_to :user, optional: true

  def merge_to_session_cart
    items = JSON.parse(items)
    session[:cart].merge!(items) { |key, oldval, newval| oldval + newval }
  end
end
