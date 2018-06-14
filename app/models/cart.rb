class Cart < ApplicationRecord
  belongs_to :user, optional: true

  def empty_cart
    self.items = '{}'
    self.save
  end
end
