class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :create_cart
  validates :firstname, :lastname, presence: true
  phony_normalize :phone_number, default_country_code: 'VN'
  validates_plausible_phone :phone_number, presence: true, with: /\A\+\d+/

  has_one :cart, dependent: :destroy
  has_many :orders

  def create_cart
    Cart.create(user: self)
  end
end
