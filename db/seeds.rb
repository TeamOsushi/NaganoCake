# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create!(
    email: 'admin@a',
    password: 'aaaaaa'
  )
   Item.create!(
    name: "ショートケーキ",
    explanation: "ショートケーキ",
    price_without_tax: "300",
    genre_id: 1,
    is_sales_status: [['販売中', true], ['販売停止', false]],
    image: open("./app/assets/images/ケーキ.jpg")
  )