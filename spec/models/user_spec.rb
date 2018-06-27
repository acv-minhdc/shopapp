require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) do
    User.create(email: 'testacc@gmail.com',
                password: 'password',
                password_confirmation: 'password',
                firstname: 'Test',
                lastname: 'Account',
                phone_number: '01654565271')
  end

  context 'Association' do
    it { should have_many(:orders) }
    it { should have_one(:cart).dependent(:destroy) }
    it 'auto create a cart after sign up' do
      expect(user.cart).to be_present
    end
  end

  context 'Validation' do
    it { should validate_presence_of(:firstname) }
    it { should validate_presence_of(:lastname) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }

    describe 'Phone number' do
      it 'can\'t save with blank phone_number' do
        user.phone_number = ''
        expect(user.save).to eq false
        expect(user.errors.full_messages).to include('Phone number can\'t be blank')
      end

      it 'reject invalid letter when save' do
        user.phone_number = '+66-2@2134567' # Thailand number
        expect(user.save).to eq true
        expect(user.phone_number).to eq('+6622134567')
      end

      it 'invalid phone can\'t save' do
        user.phone_number = '87878798546452'
        expect(user.save).to eq false
        expect(user.errors.full_messages).to include('Phone number is an invalid number')
      end

      it 'default VN code when no input country code' do
        user.phone_number = '01654565181'
        expect(user.save).to eq true
        expect(user.phone_number).to eq('+841654565181')
      end
    end
  end
end
