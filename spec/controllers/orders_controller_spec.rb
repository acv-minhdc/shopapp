require 'rails_helper'

RSpec.configure do |c|
  c.include CartHelper
  c.include OrdersHelper
end

RSpec.describe OrdersController, type: :controller do
  let!(:products) { create_list(:product, 2) }

  before(:each) do
    session[:cart] ||= {}
    add_item(products.first.id, 1)
    add_item(products.second.id, 2)
  end

  describe 'make a new order' do
    it 'render a shipping page without empty cart' do

      get :new
      expect(response).to render_template :new
    end

    it 'get alert messages when leave cart blank' do
      session[:cart] = nil
      get :new
      expect(response).to redirect_to cart_index_path
      expect(assigns(:flash).present?).to_not eq true
    end


  end

  describe 'create order' do
    it 'sucess when no login' do
      post :checkout, params: { order: { name: 'Test Name',
                                         phone_number: '01655821412',
                                         shipping_address: 'ho chi minh city' } }
      _items = JSON(convert_item_list_to_order_items(get_items_cart))

      expect(assigns(:order).items).to eq _items
      expect(assigns(:order).name).to eq 'Test Name'
      expect(assigns(:order).phone_number).to eq '01655821412'
      expect(assigns(:order).shipping_address).to eq 'ho chi minh city'
      expect(response).to redirect_to assigns(:payment).links[1].href
    end

    it 'flash alert when leave shipping info blank' do
      post :checkout, params: { order: { name: '',
                                         phone_number: '',
                                         shipping_address: '' } }

      expect(response).to render_template :new
      expect(controller).to set_flash[:error]
    end
  end
end
