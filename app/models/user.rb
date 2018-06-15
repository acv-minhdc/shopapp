class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :create_cart

  has_one :cart, dependent: :destroy
  has_many :orders

  def create_cart
    Cart.create(user: self)
  end
end
