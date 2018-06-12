class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :cart, dependent: :destroy
  after_save :create_empty_cart, on: :create

  def create_empty_cart
    Cart.create(items: '{}', user_id: id)
  end
end
