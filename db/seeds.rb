# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# require 'faker'

# Product.delete_all

# 676.times do
#     Product.create(title:Faker::Commerce.unique.product_name, 
#                    price:Faker::Commerce.price, 
#                    stock_quantity: Faker::Number.number(digits: 4))
# end

require "csv"

Product.delete_all
Category.delete_all

filename = Rails.root.join("db/products.csv")
puts "Loading data from the file: #{filename}"

csv_data = File.read(filename)

products = CSV.parse(csv_data, headers: true, encoding: "utf-8")

products.each do |product|
    category = Category.find_or_create_by(name: product["category"])

    if category&.valid?
        new_product = category.products.create(
            title: product["name"],
            price: product["price"],
            description: product["description"],
            stock_quantity: product["stock quantity"]
        )

        if !new_product&.valid?
            puts "Failed to create product: #{product["name"]}"
            next
        end
    end
end