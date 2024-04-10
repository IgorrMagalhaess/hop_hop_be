require 'rails_helper'

RSpec.describe DailyItinerary, type: :model do
   describe 'relationships' do
      it { should belong_to :trip }
      it { should belong_to :activity }
   end

   describe "class methods" do
      describe ".daily_activities" do
         it "it returns all daily itinerary activities for a date" do
            trip = Trip.create!({
               name: Faker::Name.name,
               location: Faker::Address.country,
               start_date: "Tue, 09 Apr 2024",
               end_date: "Wed, 17 Apr 2024",
               status: Faker::Number.between(from: 0, to: 1),
               total_budget: Faker::Number.between(from: 500, to: 10000),
               user_id: 1
            })

            5.times do
               Activity.create!({
               address: Faker::Address.street_address,
               description: Faker::Lorem.paragraph(sentence_count: 2),
               lat: Faker::Address.latitude,
               lon: Faker::Address.longitude,
               activity_type: Faker::Sport.sport(include_ancient: true),
               expenses: Faker::Number.between(from: 0, to: 500),
               rating: Faker::Number.between(from: 2.0, to: 5.0),
               })
            end

            three_activities = Activity.first(3).each do |activity|
               DailyItinerary.create!(
               trip_id: trip1.id,
               activity_id: activity.id,
               date: "Tue, 09 Apr 2024",
               time: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :short)
               )
            end

            expect(DailyItinerary.daily_activities("Tue, 09 Apr 2024")).to eq(three_activities)
         end
      end
   end
end
