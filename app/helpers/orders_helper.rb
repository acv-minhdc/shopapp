# frozen_string_literal: true
module OrdersHelper

  def create_request_payment(items, return_url, cancel_url)
    items_list = []
    total = 0
    items.each do |product, quantitty|
      items_list << {
        name: product.name,
        sku: product.id.to_s,
        price: product.price.to_s,
        currency: 'USD',
        quantity: quantitty['quantity']
      }
      total += product.price * quantitty['quantity']
    end
    PayPal::SDK::REST::Payment.new(
      intent: 'sale',
      payer: {
        payment_method: 'paypal'
      },
      redirect_urls: {
        return_url: return_url,
        cancel_url: cancel_url
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
  end

  def convert_item_list_to_order_items(item_list)
    h = {}
    item_list.each do |product, hash|
      h[product.id] = hash
    end
    h
  end

  def get_items(items)
    items = JSON.parse(items)
    products = Product.find(items.keys.map(&:to_s))
    items_order = {}
    products.each do |product|
      items_order[product] = items[product.id.to_s]
    end
    items_order
  end
end
