class AddColorsToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :color, :text, array: true, default: []
  end
end
