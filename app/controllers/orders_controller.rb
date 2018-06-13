class OrdersController < ApplicationController
  include OrdersHelper
  def index
    @orders = Order.all
  end

  def checkout
    @payment = create_request_payment(get_items_cart, execute_payment_url, root_url)
    # Request to paypal
    if @payment.create
      redirect_url = @payment.links.find { |link| link.rel == 'approval_url' }
      redirect_to redirect_url.href
    else
      redirect_to root_url, notice: @payment.error
    end
  end

  def create
    begin
      payment = Payment.find(params[:paymentId])
    rescue
      redirect_to root_path, notice: 'Payment not found'
    end
    # Order.create
    if payment.execute(payer_id: params[:PayerID])
      flash[:success] = 'Execute payment successfully'
    else
      flash[:success] = 'Execute payment fail'
    end
    redirect_to root_url
  end
end
