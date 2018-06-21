require 'rails_helper'

RSpec.configure do |c|
  c.include CartHelper
  c.include OrdersHelper
end

RSpec.describe OrdersController, type: :controller do
  let!(:products) { create_list(:product, 2) }

  describe 'make a new order' do
    it 'render a shipping page without empty cart' do
      session[:cart] ||= {}
      add_item(products.first.id, 1)
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'create order' do
    it 'sucess when no login' do
      session[:cart] ||= {}
      add_item(products.first.id, 1)
      add_item(products.second.id, 2)
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
  end
end
