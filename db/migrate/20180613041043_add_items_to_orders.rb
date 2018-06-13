class AddItemsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :items, :json
  end
end
