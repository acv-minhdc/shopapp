# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
Product.destroy_all
Category.destroy_all

# Restart increse value for database
tables = ['users', 'products', 'categories']
auto_inc_val = 1
# For postgres database
tables.each do |table|
  ActiveRecord::Base.connection.execute(
    "ALTER SEQUENCE #{table}_id_seq RESTART WITH #{auto_inc_val}"
  )
end


u = User.create email: 'ogremoon54@gmail.com', firstname: 'minh', lastname: 'dao', password: '123456'
Cart.create(user_id: u, items: '{}', )
# Get products
require_relative 'webhoseio'

webhoseio = Webhoseio.new('4e109559-4123-4c01-9401-a31bea4718d8')
query_params = {
  'q': "category:fashion || category:books || category:cell-phones-smartphones || category:cars || category:womens-clothing || category:computers || category:music || category:laptops-netbooks || category:skin-care || category:crafts",
  'ts': "1525370262537"
}
output = webhoseio.query('productFilter', query_params)

# Save to database
random = Random.new
3.times do
  output['products'].each do |product|
    category = product['categories'].sample
    c = Category.new(name: category)
    if c.valid?
      c.save!
    else
      c = Category.find_by(name: category)
    end
    Product.create!(name: product['name'], description: product['description'], category: c, price: product['price'], image_url: product['images'].try(:first))
  end
  random.rand(1..5).times { output = webhoseio.get_next() }
end
Admin.create!(email: 'admin@example.com', password: 'password')
