class Category < ApplicationRecord
  has_many :products
  validates :name, presence: true, uniqueness: true

  self.per_page = 15
end
