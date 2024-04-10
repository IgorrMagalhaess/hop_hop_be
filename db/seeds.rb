# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

5.times do
Trip.create!({
  name: Faker::Name.name,
  location: Faker::Address.country,
  start_date: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
  end_date: Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 3),
  status: Faker::Number.between(from: 0, to: 1),
  total_budget: Faker::Number.between(from: 500, to: 10000),
  user_id: 1

})
end

5.times do
  DailyItinerary.create!({
    trip_id: Faker::Number.between(from: 1, to: 5),
    date: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
    time: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now + 3)
  })
end
5.times do
  Activity.create!({
    address: Faker::Address.street_address,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    lat: Faker::Address.latitude,
    lon: Faker::Address.longitude,
    activity_type: Faker::Sport.sport(include_ancient: true),
    expenses: Faker::Number.between(from: 0, to: 500),
    rating: Faker::Number.between(from: 2.0, to: 5.0),
    itinerary_id: Trip.last.id,
    date: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now + 3),
    time: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now + 3)
  })
end

Accomodation.create!({
  name: Faker::Company.name,
  trip_id: Trip.last.id,
  address: Faker::Address.street_address,
  lat: Faker::Address.latitude,
  lon: Faker::Address.longitude,
  type_of_accomodation: Faker::Number.between(from: 0, to: 1),
})

7.times do
  Activity.create!({
    address: Faker::Address.street_address,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    lat: Faker::Address.latitude,
    lon: Faker::Address.longitude,
    activity_type: Faker::Sport.sport(include_ancient: true),
    expenses: Faker::Number.between(from: 0, to: 500),
    rating: Faker::Number.between(from: 2.0, to: 5.0),
    trip_id: Trip.first.id,
    date: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now + 3),
    time: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now + 3)
  })

  Accomodation.create!({
    name: Faker::Company.name,
    trip_id: Trip.first.id,
    address: Faker::Address.street_address,
    lat: Faker::Address.latitude,
    lon: Faker::Address.longitude,
    type_of_accomodation: Faker::Number.between(from: 0, to: 1),
  })
end
