require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let!(:category) { create(:category) }
  let!(:products1) { create_list(:product, 4, category: category) }

  describe 'get #index' do
    it 'get list categories' do
      get :index
      expect(assigns(:categories).count).to eq 1
    end
  end

  describe 'get #show' do
    it 'get list products of first category' do
      get :show, params: { id: category.id }
      expect(assigns(:products).count).to eq category.products.count
    end
  end
end
