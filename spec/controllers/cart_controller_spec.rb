require 'rails_helper'

RSpec.configure do |config|
  config.include CartHelper
end

RSpec.describe CartController, type: :controller do
  let!(:products) { create_list(:product, 2) }

  before(:each) do
    session[:cart] ||= {}
    add_item?(products.first.id, 1)
    add_item?(products.second.id, 2)
  end

  describe 'get cart index' do
    it 'success' do
      get :index
      expect(assigns(:items).keys.size).to eq products.size
    end
  end

  describe 'post add item' do
    it 'add a product default with quantity = 1' do
      session[:cart] = nil
      post :add, params: { id: products.first.id }
      expect(get_items_cart.count).to eq 1
    end

    it 'add a product default with quantity param' do
      session[:cart] = nil
      post :add, params: { id: products.first.id, quantity: 10 }
      expect(get_items_cart.values.first['quantity']).to eq 10
    end

    it 'alert whern post with invalid quantity' do
      post :add, params: { id: products.first.id, quantity: -1 }
      expect(flash[:warning]).to match(/Invalid input/)
    end

    it 'alert whern post with invalid product id' do
      post :add, params: { id: -5, quantity: -1 }
      expect(flash[:warning]).to match(/Invalid input/)
    end
  end

  describe 'post change quantity in cart view' do
    it 'change number quantity valid' do
      post :change_quantity, params: { id: products.first.id, quantity: 7 }
      expect(get_items_cart.values.first['quantity']).to eq 7
    end

    it 'alert warning when post blank' do
      post :change_quantity, params: { id: products.first.id, quantity: '' }
      expect(flash[:warning]).to match(/Quantity invalid/)
      expect(response).to redirect_to cart_index_path
    end

    it 'alert warning when post negative number' do
      post :change_quantity, params: { id: products.first.id, quantity: -2 }
      expect(flash[:warning]).to match(/Quantity invalid/)
      expect(response).to redirect_to cart_index_path
    end
  end

  describe 'empty cart' do
    it 'method delete' do
      delete :empty
      expect(get_items_cart.count).to eq 0
    end
  end
end
