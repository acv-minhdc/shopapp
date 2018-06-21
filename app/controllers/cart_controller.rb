class CartController < ApplicationController
  include CartHelper

  before_action :init_cart, except: [:empty]
  after_action :sync_cart, except: %i[index checkout empty]

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
    add_item(params[:id], quantity)
    redirect_to cart_index_path
  end

  # Delete a product with all quantity
  def delete
    session[:cart].delete(params[:id])
    flash[:success] = 'Delete done'
    redirect_to cart_index_path
  end

  def change_quantity
    if params[:quantity].blank? || params[:quantity].to_i < 1
      flash[:warning] = 'Quantity cant\'t be blank'
      # return redirect_back fallback_location: product_path(params[:id])
    else
      session[:cart][params[:id]] = params[:quantity].to_i
    end
    redirect_to cart_index_path
  end

  def empty
    empty_cart
    flash[:success] = 'Empty done'
    redirect_to cart_index_path
  end

  private

  def init_cart
    session[:cart] ||= {}
  end
end
