# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   endUser.create!(email: 'user@email.com', password: '123456', role: :admin)User.create!(email: 'user@email.com', password: '123456', role: :admin)User.create!(email: 'user@email.com', password: '123456', role: :admin)User.create!(email: 'user@email.com', password: '123456', role: :admin)User.create!(email: 'user@email.com', password: '123456', role: :admin)User.create!(email: 'user@email.com', password: '123456', role: :admin)User.create!(email: 'user@email.com', password: '123456', role: :admin)

user = User.find_or_initialize_by(email_address: "admin@example.com")
if user.new_record?
  user = User.create!(
    email_address: "admin@example.com",
    name: "admin",
    password: "password",
    role: 0
  )
  puts "Admin user #{user.name} has been created."
else
  puts "Admin user already exists in database"
end

client = Client.find_or_initialize_by(email: "client@example.com")
if client.new_record?
  client = Client.create!(
    name: "client",
    email: "client@example.com",
    birthdate: "2001-01-01"
  )
  puts "Client #{client.name} has been created."
else
  puts "Client already exists in database"
end

2.times do |i|
  sale = Sale.find_or_initialize_by(client: client, date: Date.today + i.days)
  if sale.new_record?
    Sale.create!(
      client: client,
      date: Date.today + i.days,
      value: (100 + i * 50),
      description: "example description"
    )
    puts "Sale ##{i + 1} for client #{client.name} has been created."
  else
    puts "Sale ##{i + 1} already exists for client #{client.name}"
  end
end
