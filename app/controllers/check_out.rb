class CheckOut
  include PayPal::SDK::REST

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
    return Payment.new(
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
end
