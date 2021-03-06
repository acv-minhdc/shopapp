class OrdersController < ApplicationController
  include OrdersHelper
  include CartHelper

  before_action :authenticate_user!, only: %i[index show]
  before_action :set_order, :set_payment, only: %i[execute_payment show]
  before_action :check_cart, only: %i[new checkout]

  def index
    @orders = current_user.orders.paginate(page: params[:page]).order(:created_at => :asc)
  end

  def new
    @order = Order.new(user: current_user)
    @item_list = get_items_cart
  end

  def checkout
    item_list = get_items_cart
    @payment = create_request_payment(item_list, execute_payment_orders_url, root_url)
    # Request to paypal
    if @payment.create
      @order = Order.new(order_params.merge(user_id: current_user.try(:id),
                                            items: JSON(convert_item_list_to_order_items(item_list)),
                                            total_amount: @total_price,
                                            payment_id: @payment.id))
      if @order.save
        redirect_to @payment.links[1].href
      else
        flash[:error] = @order.errors.full_messages
        render :new
      end
    else
      flash[:error] = @payment.error
      redirect_to root_url
    end
  end

  def show
    @items = @order.get_items
  end

  def execute_payment
    if @payment.execute(payer_id: params[:PayerID])
      flash.now[:success] = 'Execute payment successfully'
      @order.pay!
      @items = @order.get_items
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
    @payment = PayPal::SDK::REST::Payment.find(params[:paymentId])
  rescue StandardError
    redirect_to root_path, notice: 'Payment not found'
  end

  def check_cart
    if session[:cart].blank?
      flash[:warning] = 'Your cart is empty'
      redirect_to cart_index_path
    end
  end
end
