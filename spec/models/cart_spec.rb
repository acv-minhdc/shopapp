require 'rails_helper'

RSpec.describe Cart, type: :model do
  let!(:products) { create_list(:product, 2) }
  let!(:cart) { Cart.create(user: create(:user)) }

  context 'Association' do
    it { should belong_to(:user) }
  end

  # context 'Custom Validation' do
  #   describe 'save success' do
  #     it 'with valid parameter' do
  #       cart.items = JSON(products.first.id => 1, products.second.id => 2)
  #       expect(cart.save).to eq true
  #       expect(cart.errors).to be_empty
  #     end
  #   end
  #
  #   describe 'can\'t save' do
  #     it 'with empty items' do
  #       cart.items = ''
  #       expect(cart.save).to eq false
  #       expect(cart.errors.full_messages).to include('Items can\'t be blank')
  #     end
  #
  #     it 'with invalid id product' do
  #       cart.items = JSON('-1' => 3, '0' => 1)
  #       expect(cart.save).to eq false
  #       expect(cart.errors.full_messages).to include('Productids invalid')
  #     end
  #
  #     it 'with invalid quantity' do
  #       cart.items = JSON(products.first.id.to_s => 0, products.second.id.to_s => 1)
  #       expect(cart.save).to eq false
  #       expect(cart.errors.full_messages).to include('Quantity invalid')
  #     end
  #   end
  # end
end
