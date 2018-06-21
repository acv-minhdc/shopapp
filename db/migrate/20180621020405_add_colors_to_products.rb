class AddColorsToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :colors, :text, array: true, default: []
  end
end
