# Define some sample names, locations, and types of accommodations
sample_names = ["Adventure in the Mountains", "Beach Getaway", "Cultural Exploration", "City Escape", "Road Trip Extravaganza"]
sample_locations = ["Switzerland", "Thailand", "Italy", "Australia", "Canada"]
sample_accommodation_types = ["Luxury Villa", "Cozy Cabin", "Boutique Hotel", "Beach Resort", "Rustic Lodge"]

# Create 30 trips
30.times do
  Trip.create!({
    name: sample_names.sample,
    location: sample_locations.sample,
    start_date: DateTime.now,
    end_date: DateTime.now + rand(10..50),
    status: rand(0..1),
    total_budget: rand(500..10000),
    user_id: rand(1000..1005)
  })
end
puts "Created Trips"

Trip.all.each do |trip|
  trip.accommodations.create!({
    trip_id: trip.id,
    name: "#{sample_accommodation_types.sample} in #{trip.location}",
    address: "#{rand(1..100)} #{["Main", "High", "Oak", "Park"].sample} Street",
    lat: rand(-90.0..90.0),
    lon: rand(-180.0..180.0),
    check_in: trip.start_date,
    check_out: trip.end_date,
    type_of_accommodation: sample_accommodation_types.sample,
    expenses: rand(500..5000),
  })
end

puts "Created Accommodations"
puts "Created Daily Itineraries"

# Generating activities for each daily itinerary
DailyItinerary.all.each do |daily_itinerary|
  rand(1..7).times do
    daily_itinerary.activities.create!({
      name: ["Hiking", "Snorkeling", "Museum Visit", "City Tour", "Cooking Class"].sample,
      address: "#{rand(1..100)} #{["Main", "High", "Oak", "Park"].sample} Street",
      description: ["Enjoy a day of adventure!", "Discover local culture.", "Relax and unwind."].sample,
      lat: rand(-90.0..90.0),
      lon: rand(-180.0..180.0),
      expenses: rand(0..500),
      rating: rand(2.0..5.0).round(1),
      time: daily_itinerary.date + rand(0.0..0.9), # Random time within the day
    })
  end
end

puts "Created Activities"
