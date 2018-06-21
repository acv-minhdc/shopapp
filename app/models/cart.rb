class Cart < ApplicationRecord
  belongs_to :user
  before_save :check_items_json

  def check_items_json
    if items.blank?
      errors.add(:items, 'can\'t be blank')
      throw(:abort)
    end
    _items = JSON.parse(items)
    begin
      Product.find(_items.keys.map(&:to_s))
    rescue
      errors.add(:productids, 'invalid')
      throw(:abort)
    end
    _items.values.each do |quantity|
      if quantity < 1
        errors.add(:quantity, 'invalid')
        throw(:abort)
      end
    end
  end
end
