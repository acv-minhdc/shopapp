class Order < ApplicationRecord
  validates :name, :phone_number, :shipping_address, :payment_id, presence: true
  belongs_to :user, optional: true
  after_initialize :get_info_user

  def get_info_user
    return if user.blank?
    self.name = name || [user.firstname, user.lastname].join(' ')
    self.phone_number = phone_number || user.phone_number
    self.shipping_address = shipping_address || user.address
  end

  def pay
    self.pay_status = true
    save
  end

  self.per_page = 10
end
