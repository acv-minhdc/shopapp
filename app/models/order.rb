class Order < ApplicationRecord
  validates :name, :phone_number, :shipping_address, :payment_id, presence: true
  belongs_to :user, optional: true

  self.per_page = 10
end
