class Category < ApplicationRecord
  has_many :products
  validates :name, presence: true, uniqueness: true

  default_scope { order(name: :asc) }

  self.per_page = 15
end
