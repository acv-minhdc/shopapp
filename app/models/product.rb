class Product < ApplicationRecord
  validates :name, :description, presence: true
  validate :name_is_shorter_than_description
  validates :price, presence: true, numericality: { greater_than: 0 }
  before_save :strip_html_from_description
  before_save :lower_case_name
  belongs_to :category, optional: true

  scope :published, -> { where(published: true) }
  scope :priced_more_than, ->(price) { where('price > ?', price) }

  def name_is_shorter_than_description
    return if name.blank? || description.blank?
    return if description.length >= name.length
    errors.add(:description, 'can\'t be shorter than name')
  end

  def strip_html_from_description
    self.description = ActionView::Base.full_sanitizer.sanitize(description)
  end

  def lower_case_name
    self.name = name.downcase
  end

  self.per_page = 6

end
