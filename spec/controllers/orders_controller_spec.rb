require 'rails_helper'

RSpec.configure do |config|
  config.include CartHelper
  config.include OrdersHelper
end

RSpec.describe OrdersController, type: :controller do
  let!(:products) { create_list(:product, 2) }

  before(:each) do
    session[:cart] ||= {}
    add_item?(products.first.id, 1)
    add_item?(products.second.id, 2)
  end

  describe 'make a new order' do
    it 'render a shipping page without empty cart' do
      get :new
      expect(response).to render_template :new
      expect(assigns(:order)).to be_instance_of(Order)
    end

    it 'get alert messages when leave cart blank' do
      session[:cart] = nil
      get :new
      expect(response).to redirect_to cart_index_path
      expect(flash[:warning]).to match(/Your cart is empty/)
    end
  end

  describe 'create order' do
    it 'success when no login' do
      post :checkout, params: { order: { name: 'Test Name',
                                         phone_number: '01655821412',
                                         shipping_address: 'ho chi minh city' } }
      _items = JSON(convert_item_list_to_order_items(get_items_cart))

      expect(assigns(:order).items).to eq _items
      expect(assigns(:order).name).to eq 'Test Name'
      expect(assigns(:order).phone_number).to eq '+841655821412'
      expect(assigns(:order).shipping_address).to eq 'ho chi minh city'
      expect(response).to redirect_to assigns(:payment).links[1].href
    end

    it 'flash alert when leave shipping info blank' do
      post :checkout, params: { order: { name: '',
                                         phone_number: '',
                                         shipping_address: '' } }

      expect(response).to render_template :new
      expect(flash[:error]).to include("Name can't be blank")
      expect(flash[:error]).to include("Phone number can't be blank")
      expect(flash[:error]).to include("Shipping address can't be blank")
    end
  end

  describe 'index order' do
    before(:each) do
      @user = User.create(email: 'testacc@gmail.com',
                          password: 'password',
                          password_confirmation: 'password',
                          firstname: 'Name',
                          lastname: 'Lord',
                          phone_number: '01654565241',
                          address: 'q9 tphcm')

      items = get_items_cart
      @order = Order.create!(user: @user,
                             items: JSON(convert_item_list_to_order_items(items)),
                             payment_id: create_request_payment(items, execute_payment_orders_url, root_url))
    end

    it 'when user logged in' do
      sign_in(@user)
      get :index
      expect(assigns(:orders).count).to eq Order.count
      expect(response).to render_template :index
    end

    it 'redirect to login page when not logged' do
      get :index
      expect(response).to_not render_template :index
      expect(response).to redirect_to new_user_session_path
    end

    it 'show a order when logged in' do
      sign_in(@user)
      get :show, params: { paymentId: @order.payment_id }
      expect(assigns(:order)).to eq @order
    end

    it 'not show order for guest not login' do
      get :show, params: { paymentId: @order.payment_id }
      expect(assigns(:order)).to_not eq @order
      expect(response).to redirect_to new_user_session_path
    end

    it 'alert when order not existed' do
      sign_in(@user)
      get :show, params: { paymentId: '123456789' }
      expect(flash[:notice]).to match(/Order payment not found/)
    end
  end
end
