class OrdersController < ApplicationController
  include PayPal::SDK::REST
  def index
    @orders = Order.all
  end

  def checkout
    @payment = CheckOut.new
    @payment = @payment.create_payment(get_items_cart, execute_payment_url, root_url)
    if @payment.create
      redirect_url = @payment.links.find { |link| link.rel == 'approval_url' }
      redirect_to redirect_url.href
    else
      redirect_to root_url, notice: @payment.error
    end
  end

  def create
    begin
      payment = PayPal::SDK::REST::Payment.find(params[:paymentId])
    rescue
      redirect_to root_path, notice: 'Payment not found'
    end
    # Order.create
    if payment.execute(payer_id: params[:PayerID])
      redirect_to root_url, notice: 'Execute payment successfully'
    else
      redirect_to root_url, notice: 'Execute fail'
    end
  end
end
