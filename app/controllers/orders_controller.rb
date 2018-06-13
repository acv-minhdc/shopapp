class OrdersController < ApplicationController
  before_action :set_order, only: [:execute_payment]

  include OrdersHelper
  def index
    @orders = Order.all
  end

  def new
    @order = Order.new(name: current_user.try(:firstname), phone_number: current_user.try(:phone_number),
                      shipping_address: current_user.try(:address))
  end

  def checkout
    return redirect_to cart_index_path, notice: 'Your cart is empty' if session[:cart].empty?
    item_list = get_items_cart
    @payment = create_request_payment(item_list, execute_payment_orders_url, root_url)
    # Request to paypal
    if @payment.create
      @order = Order.new(order_params.merge(user_id: current_user.try(:id), items: JSON(convert_item_list_to_order_items(item_list)),
                          total_amount: @total_price, payment_id: @payment.id))
      if @order.save
        redirect_url = @payment.links.find { |link| link.rel == 'approval_url' }
        redirect_to redirect_url.href
      else
        redirect_to root_url, notice: 'Something goes wrong when create order'
      end
    else
      redirect_to root_url, notice: @payment.error
    end
  end

  def update

  end

  def execute_payment
    begin
      payment = PayPal::SDK::REST::Payment.find(params[:paymentId])
    rescue
      redirect_to root_path, notice: 'Payment not found'
    end
    if payment.execute(payer_id: params[:PayerID])
      flash.now[:success] = 'Execute payment successfully'
      @order.pay_status = true
      @order.save!
    else
      flash.now[:error] = 'Execute payment fail'
    end
    @items_order = get_items_order(@order.items)
    render 'show'
  end

  private

  def order_params
    params.require(:order).permit(:name, :phone_number, :shipping_address)
  end

  def set_order
    @order = Order.find_by(payment_id: params[:paymentId])
    redirect_to root_path, notice: 'Order payment not found' if @order.nil?
  end

end
