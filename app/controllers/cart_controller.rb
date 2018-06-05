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

  # Add
  def add(quantity = 1)
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

  # Delete
  def delete
    session[:cart] ||= {}
    products = session[:cart][:products]
    id = params[:id]
    all = params[:all]

    # Is ID present?
    if id.blank?
      products.delete
    else
      if all.blank?
        products.delete_at(products.index(id) || products.length)
      else
        products.delete(params['id'])
          end
      end

    # Handle the request
    respond_to do |format|
      format.json { render json: cart_session.build_json }
      format.html { redirect_to cart_index_path }
    end
  end
end
