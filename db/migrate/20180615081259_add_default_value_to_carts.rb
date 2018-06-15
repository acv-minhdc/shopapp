class AddDefaultValueToCarts < ActiveRecord::Migration[5.2]
  def change
    change_column :carts, :items, :json, default: '{}'
  end
end
