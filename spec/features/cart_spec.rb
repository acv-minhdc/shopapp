require 'rails_helper'

RSpec.feature 'cart still be there' do
  let!(:products) { create_list(:product, 2) }
  let!(:user) { User.create(email: 'testuseracv@yopmail.com', password: 'password', password_confirmation: 'password') }

  scenario 'when sign up' do
    reset_session!

    visit products_url
    click_on 'Add to Cart', match: :first

    visit new_user_registration_url
    fill_in 'Email', with: 'testcart@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_on 'Sign up'

    visit cart_index_url
    expect(page).to have_content products.last.name.capitalize
  end

  scenario '+ merge cart user when login' do
    reset_session!

    visit new_user_session_url
    fill_in 'Email', with: 'testuseracv@yopmail.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'
    # when login
    visit products_url
    click_on 'Add to Cart', match: :first
    click_on 'Logout'

    # when no login
    visit products_url
    click_on products.first.name
    click_on 'Add to cart'

    # when login comeeback
    visit new_user_session_url
    fill_in 'Email', with: 'testuseracv@yopmail.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'

    # expect 2 products in cart
    visit cart_index_url
    expect(page).to have_content products.last.name.capitalize
    expect(page).to have_content products.first.name.capitalize
  end



end
