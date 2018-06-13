class RemoveUnnecessaryAttributeFromCart < ActiveRecord::Migration[5.2]
  def change
    remove_column :carts, :item_cart_id
    drop_table :cart_items
  end
end
