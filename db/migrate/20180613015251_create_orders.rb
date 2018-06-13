class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :shipping_address
      t.integer :cart_id, index: true
      t.integer :user_id, index: true
      t.decimal :total_amount, precision: 10, scale: 2
      t.string :note

      t.timestamps
    end
  end
end
