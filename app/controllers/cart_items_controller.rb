class CartItemsController < ApplicationController
  before_action :set_cart_item, only: [:destroy]

  def index
    @cart = current_cart
  end

  def create
    @cart = current_cart
    @cart.add_item(cart_item_params)

    if @cart.save
      redirect_back fallback_location: products_path
    else
      flash[:error] = 'There was a problem adding this item to your cart.'
      redirect_back fallback_location: products_path
    end
  end

  def destroy
    @cart_item.destroy
    flash[:sucess] = 'Delete successfully.'
    redirect_back carts_path
  end

  private

  def set_cart_item
    @cart_item = CartItem.find[params[:id]]
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :cart_id, :quantity)
  end
end
