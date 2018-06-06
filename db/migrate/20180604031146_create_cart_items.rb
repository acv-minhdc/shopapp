class CreateCartItems < ActiveRecord::Migration[5.2]
  def change
    create_table :cart_items do |t|
      t.integer :quantity
      t.integer :cart_id, index: true
      t.integer :product_id, index: true
      t.timestamps
    end
  end
end
