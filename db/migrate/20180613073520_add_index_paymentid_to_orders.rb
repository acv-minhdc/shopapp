class AddIndexPaymentidToOrders < ActiveRecord::Migration[5.2]
  def change
    add_index :orders, :payment_id
  end
end
