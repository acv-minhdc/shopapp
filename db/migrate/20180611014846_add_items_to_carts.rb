class AddItemsToCarts < ActiveRecord::Migration[5.2]
  def change
    add_column :carts, :items, :json
  end
end
