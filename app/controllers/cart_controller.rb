class CartController < ApplicationController
  before_action :init_cart
  after_action :sync_cart, except: [:index, :checkout]

  # Index
  def index
    @items = get_items_cart
  end

  # Add product with quantity
  def add
    quantity = params[:quantity].try(:to_i) || 1
    if quantity < 1
      flash[:warning] = 'Quantity cant\'t be less than 1'
      return redirect_back fallback_location: product_path(params[:id])
    end
    # If exists, add new, else create new variable
    if  session[:cart][params[:id]].present?
      session[:cart][params[:id]] += quantity
    else
      session[:cart][params[:id]] = quantity
    end
    redirect_to cart_index_path
  end

  # Delete a product with all quantity
  def delete
    session[:cart].delete(params[:id])
    flash[:success] = 'Delete done'
    redirect_to cart_index_path
  end

  def empty
    session[:cart] = {}
  end

  private

    def init_cart
      session[:cart] ||= {}
    end

    def sync_cart
      if user_signed_in?
        current_user.cart.items = JSON(session[:cart]) if session[:cart]
        current_user.cart.save!
      end
    end

end
