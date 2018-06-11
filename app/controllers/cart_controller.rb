class CartController < ApplicationController
  before_action :set_cart
  after_action :sync_cart, except: [:index, :checkout]

  include PayPal::SDK::REST
  # Index
  def index
    @items = get_items_cart
  end

  # Add product with quantity
  def add
    quantity = params[:quantity].try(:to_i) || 1
    if quantity < 1
      flash[:warning] = 'Quantity cant\'t be less than 1'
      return redirect_to product_path(params[:id])
    end
    products = session[:cart][params[:id].to_s]
    # If exists, add new, else create new variable
    if products.present?
      session[:cart][params[:id].to_s] += quantity
    else
      session[:cart][params[:id].to_s] = quantity
    end
    redirect_to cart_index_path
  end

  # Delete a product with all quantity
  def delete
    session[:cart].delete(params[:id].to_s)
    flash[:success] = 'Delete done'
    redirect_to cart_index_path
  end

  def empty
    session[:cart] = {}
  end

  private
    def set_cart
      session[:cart] ||= {}
    end

    def sync_cart
      if user_signed_in?
        current_user.cart.items = JSON(session[:cart])
      end
    end
end
