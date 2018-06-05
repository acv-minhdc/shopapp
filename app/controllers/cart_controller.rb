class CartController < ApplicationController
  include ApplicationHelper
  # Index
  def index
    products = session[:cart]
    if (products && products != {})

        #Get products from DB
        products_array = Product.find(products.keys.map(&:to_s))
        #Create Qty Array
        products_new = {}
        products_array.each{
            |a| products_new[a] = {'quantity' => products[a.id.to_s]}
        }
        @items = products_new
    end
  end

  # Add product with quantity
  def add
    quantity = params[:quantity].try(:to_i) || 1
    if quantity <= 0
      flash[:warning] = 'Quantity cant\'t be less than 1'
      return redirect_to product_path(params[:id])
    end
    session[:cart] ||= {}
    products = session[:cart][params[:id].to_s]
    # If exists, add new, else create new variable
    if products && products != {}
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

end
