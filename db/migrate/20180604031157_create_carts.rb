class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.integer :item_cart_id, index: true
      t.integer :user_id, index: true
      t.timestamps
    end
  end
end
