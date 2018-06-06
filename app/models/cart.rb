class Cart < ApplicationRecord
  has_many :cart_items
  belongs_to :user, optional: true

  def add_item(cart_item_params)
    current_item = cart_items.find_by(product_id: cart_item_params[:product_id])

    if current_item
      current_item.quantity += cart_item_params[:quantity].to_i
      current_item.save
    else
      new_item = cart_items.build(product_id: cart_item_params[:product_id],
                                   quantity: cart_item_params[:quantity])
    end
    new_item
  end
end
