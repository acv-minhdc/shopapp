class OrdersController < ApplicationController
  include OrdersHelper
  include CartHelper

  before_action :set_order, only: [:execute_payment, :show]
  before_action :authenticate_user!, only: [:index, :show]
  before_action :set_payment, only: [:execute_payment]

  def index
    @orders = Order.where(user: current_user).paginate(page: params[:page]).order(:created_at => :asc)
  end

  def new
    @order = Order.new(user: current_user)
    return redirect_to cart_index_path, notice: 'Your cart is empty' if session[:cart].empty?
    @item_list = get_items_cart
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
        redirect_to @payment.links[1].href
      else
        redirect_to root_url, notice: 'Can\'t leave shipping info blank'
      end
    else
      redirect_to root_url, notice: @payment.error
    end
  end

  def show
    @items = get_items(@order.items)
  end

  def execute_payment
    if @payment.execute(payer_id: params[:PayerID])
      flash.now[:success] = 'Execute payment successfully'
      @order.pay_status = true
      @order.save!
      @items = get_items(@order.items)
      empty_cart
      render 'show'
    else
      flash[:error] = 'Execute payment fail'
      redirect_to root_path
    end
  end

  private

  def order_params
    params.require(:order).permit(:name, :phone_number, :shipping_address)
  end

  def set_order
    @order = Order.find_by(payment_id: params[:paymentId], user: current_user)
    redirect_to root_path, notice: 'Order payment not found' if @order.blank?
  end

  def set_payment
    begin
      @payment = PayPal::SDK::REST::Payment.find(params[:paymentId])
    rescue
      redirect_to root_path, notice: 'Payment not found'
    end
  end

end
