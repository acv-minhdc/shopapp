class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def create
    payment = PayPal::SDK::REST::Payment.find(params[:paymentId])
    # Order.create(response: JSON(params.slice(:paymentId, :token, :PayerID)))
    # redirect_to root_url, notice: 'Payment Succesful'
    if payment.execute(payer_id: params[:PayerID])
      redirect_to root_url, notice: 'Execute payment successfully'
    # Note that you'll need to `Payment.find` the payment again to access user info like shipping address
    else
      redirect_to root_url, notice: 'Execute fail'
    end
  end
end
