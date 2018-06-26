class Order < ApplicationRecord
  validates :name, :phone_number, :shipping_address, :payment_id, presence: true
  phony_normalize :phone_number, default_country_code: 'VN'
  validates_plausible_phone :phone_number, presence: true, with: /\A\+\d+/
  belongs_to :user, optional: true
  after_initialize :get_info_user
  before_save

  def get_info_user
    return if user.blank?
    self.name = name || [user.firstname, user.lastname].join(' ')
    self.phone_number = phone_number || user.phone_number
    self.shipping_address = shipping_address || user.address
  end

  def pay!
    self.pay_status = true
    save
  end

  def get_items
    items = JSON.parse(self.items)
    products = Product.find(items.keys)
    items_order = {}
    products.each do |product|
      items_order[product] = items[product.id.to_s]
    end
    items_order
  end

  self.per_page = 10
end
