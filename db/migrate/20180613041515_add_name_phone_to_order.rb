class AddNamePhoneToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :name, :string
    add_column :orders, :phone_number, :string, limit: 20
  end
end
