require 'rails_helper'

RSpec.feature 'Nonuser/user can see all categories', type: :feature do
  before(:each) do
    amount = Category.per_page
    create_list(:category, amount)
  end

  scenario 'with entries == page_size' do
    visit categories_path
    # save_and_open_page
    expect(page).to have_no_xpath("//*[@class='pagination']//a[text()='2']")
  end

  scenario 'with entries > page_size' do
    create(:category)
    visit categories_path
    expect(page).to have_xpath("//*[@class='pagination']//a[text()='2']")
  end

  scenario 'with entries > page_size it correctly redirects to next page' do
    create(:category)
    visit categories_path
    find("//*[@class='pagination']//a[text()='2']").click
    expect(page.status_code).to eq(200)
  end
end
