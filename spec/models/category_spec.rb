require 'rails_helper'

RSpec.describe Category, type: :model do
  context 'Validation' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  context 'Association' do
    it { should have_many(:products) }
  end
end
