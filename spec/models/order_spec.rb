require 'rails_helper'

RSpec.describe Order, type: :model do

  context 'Validation' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:phone_number) }
    it { should validate_presence_of(:shipping_address) }
    it { should validate_presence_of(:payment_id) }
  end

  context 'Association' do
    it { should belong_to(:user) }
  end

end
