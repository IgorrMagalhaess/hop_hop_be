# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
30.times do
  Trip.create!({
    name: Faker::Name.name,
    location: Faker::Address.country,
    start_date: Faker::Time.between(from: DateTime.now, to: DateTime.now + 50),
    end_date: Faker::Time.between(from: DateTime.now + 51, to: DateTime.now + 75),
    status: Faker::Number.between(from: 0, to: 1),
    total_budget: Faker::Number.between(from: 500, to: 10000),
    user_id: Faker::Number.between(from: 1000, to: 1005)
  })
end
puts "Created Trips"

Trip.all.each do |trip|
  trip.accommodations.create!({
    trip_id: trip.id,
    name: Faker::Name.name,
    address: Faker::Address.street_address,
    lat: Faker::Address.latitude,
    lon: Faker::Address.longitude,
    check_in: trip.start_date,
    check_out: trip.end_date,
    type_of_accommodation: Faker::Name.name,
    expenses: Faker::Number.between(from: 500, to: 5000),
  })
  # Faker::Number.between(from: 3, to: 10).times do
  #   trip.daily_itineraries.create!({
  #     trip_id: trip.id,
  #     date: Faker::Time.between(from: trip.start_date, to: trip.end_date)
  # })
  # end
end

puts "Created Accommodations"
puts "Created Daily Itineraries"


DailyItinerary.all.each do |daily_itinerary|
  Faker::Number.between(from: 1, to: 7).times do
    daily_itinerary.activities.create!({
      name: Faker::Sport.sport(include_ancient: true),
      address: Faker::Address.street_address,
      description: Faker::Lorem.paragraph(sentence_count: 2),
      lat: Faker::Address.latitude,
      lon: Faker::Address.longitude,
      expenses: Faker::Number.between(from: 0, to: 500),
      rating: Faker::Number.between(from: 2.0, to: 5.0),
      time: Faker::Time.between(from: daily_itinerary.date, to: daily_itinerary.date + 0.5),
    })
  end
end

puts "Created Activities"
