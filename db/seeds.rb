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
Order.destroy_all
Admin.destroy_all

# Restart increse value for database
tables = ['users', 'products', 'categories', 'orders', 'admins']
auto_inc_val = 1
# For postgres database
tables.each do |table|
  ActiveRecord::Base.connection.execute(
    "ALTER SEQUENCE #{table}_id_seq RESTART WITH #{auto_inc_val}"
  )
end


User.create email: 'ogremoon54@gmail.com', firstname: 'minh', lastname: 'dao', password: '123456', password_confirmation: '123456', address: 'Thu Duc TPHCM', phone_number: '01654565281'
# Get products
require_relative 'webhoseio'

webhoseio = Webhoseio.new('4e109559-4123-4c01-9401-a31bea4718d8')
query_params = {
	'q': "language:english country:US (category:phone || category:computers || category:cell-phones-accessories || category:camera || category:laptops-netbooks)",
	'ts': "1521511574512"
}
output = webhoseio.query('productFilter', query_params)

# Save to database
colors = ['while', 'black', 'blue', 'yeallow', 'pink', 'red', 'green', 'purple', 'gray', 'orange']
sizes = ['S', 'M', 'L']
10.times do
  output['products'].each_with_index do |product, index|
    next if index % 3 != 0 # Avoid duplicate product
    random_category = product['categories'].sample
    category = Category.new(name: random_category)
    if category.valid?
      category.save!
    else
      category = Category.find_by(name: random_category)
    end
    Product.create!(name: product['name'],
                    description: product['description'],
                    category: category,
                    price: product['price'],
                    image_url: product['images'].try(:first),
                    colors: colors.sample(3),
                    sizes: sizes)
  end
  output = webhoseio.get_next()
end
Admin.create!(email: 'admin@example.com', password: 'password')
