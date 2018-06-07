class CartController < ApplicationController
  include PayPal::SDK::REST
  # Index
  def index
    session[:cart] ||= {}
    products = session[:cart]
    if products && products != {}

      # Get products from DB
      products_array = Product.find(products.keys.map(&:to_s))
      # Create Qty Array
      products_new = {}
      products_array.each do |a|
        products_new[a] = { 'quantity' => products[a.id.to_s] }
      end
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

  def checkout
    @items = index
    items_list = []
    total = 0
    @items.each do |product, quantitty|
      items_list << {
        name: product.name,
        sku: product.id.to_s,
        price: product.price.to_s,
        currency: 'USD',
        quantity: quantitty['quantity']
      }
      total += product.price * quantitty['quantity']
    end
    @payment = Payment.new(
      intent: 'sale',
      payer: {
        payment_method: 'paypal'
      },
      redirect_urls: {
        return_url: execute_payment_url,
        cancel_url: root_url
      },
      transactions: [{
        item_list: {
          items: items_list
        },
        amount: {
          total: total.to_s,
          currency: 'USD'
        },
        description: 'This is the payment transaction description from minhacvshop.'
      }]
    )
    if @payment.create
      redirect_url = @payment.links.find { |link| link.rel == 'approval_url' }
      redirect_to redirect_url.href
    else
      redirect_to root_url, notice: @payment.error
    end
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
