require 'rails_helper'

RSpec.feature 'Nonuser/user can see all products', type: :feature do
  before(:each) {
    amount = Product.per_page
    create_list(:product, amount)

  scenario "with entries == page_size" do

    visit products_path
    #save_and_open_page
    expect(page).to have_no_xpath("//*[@class='pagination']//a[text()='2']")
  end

  scenario "with entries > page_size" do
    create(:product)
    visit products_path
    expect(page).to have_xpath("//*[@class='pagination']//a[text()='2']")
  end

  scenario "with entries > page_size it correctly redirects to next page" do
    create(:product)
    visit products_path
    find("//*[@class='pagination']//a[text()='2']").click
    expect(page.status_code).to eq(200)
  end
end
