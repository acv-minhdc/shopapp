require 'rails_helper'

RSpec.feature 'Cart', type: :feature do
  let!(:products) { create_list(:product, 2) }
  let!(:user) { User.create(email: 'testuseracv@yopmail.com', password: 'password', password_confirmation: 'password', firstname: 'minh', lastname: 'dao') }

  scenario 'save from session when sign up' do
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

  scenario 'merge session cart user when login' do
    reset_session!

    visit new_user_session_url
    fill_in 'Email', with: 'testuseracv@yopmail.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'
    # when login
    visit products_url
    click_on 'Add to Cart', match: :first
    click_on ['Hi', user.firstname].join(' ')
    click_on 'Logout'

    # when no login
    visit products_url
    click_on products.first.name.capitalize
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

  context 'cart update when' do
    it 'add a item' do
      visit products_url
      click_on 'Add to Cart', match: :first
      visit cart_index_url
      expect(page).to have_content products.last.name.capitalize
    end

    it 'remove a line', js: true do
      visit products_path
      click_on 'Add to Cart', match: :first
      visit products_path
      click_on products.first.name.capitalize
      click_on 'Add to cart'
      # find('.glyphicon.glyphicon-remove').click
      page.first('.glyphicon.glyphicon-remove').click
      page.driver.browser.switch_to.alert.accept
      expect(page).to_not have_content products.last.name.capitalize
    end

    it 'add with a number' do
      visit products_path
      click_on 'Add to Cart', match: :first
      visit products_path
      click_on products.last.name.capitalize
      fill_in 'Quantity', with: 10
      click_on 'Add to cart'
      expect(page).to have_field(name: 'quantity', with: '11')
    end
  end
end
