require 'rails_helper'

RSpec.describe Product, type: :model do
  context 'Validation' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
  end

  context 'Association' do
    it { should belong_to(:category) }
  end

  context 'Custom Validation' do
    let!(:product) { create(:product, name: 'Ruby', description: '<h1>Hello World</h1>') }
    let!(:new_product) { build(:product, description: 'Ru') }

    it 'Strips HTML from description' do
      expect(product.description).to eq 'Hello World'
    end

    it 'Make title lowcase' do
      expect(product.name).to eq 'ruby'
    end
  end
end
