class AddSizesToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :sizes, :text, array: true, default: []
  end
end
