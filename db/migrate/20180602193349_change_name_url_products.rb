class ChangeNameUrlProducts < ActiveRecord::Migration[5.2]
  def change
    rename_column :products, :url, :image_url
  end
end
