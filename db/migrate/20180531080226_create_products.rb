class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.decimal :price
      t.integer :category_id, index: true
      t.boolean :published, default: true

      t.timestamps
    end
  end
end
