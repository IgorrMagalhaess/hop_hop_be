require 'rails_helper'

RSpec.describe Trip, type: :model do
  describe 'relationships' do
  it { should have_many :daily_itineraries }
  it { should have_many(:activities).through(:daily_itineraries) }
  it { should have_many(:accomodations) }
  end

  before do
    @trip1 = Trip.create!({
      name: Faker::Name.name,
      location: Faker::Address.country,
      start_date: "Tue, 09 Apr 2024",
      end_date: "Fri, 12 Apr 2024",
      status: Faker::Number.between(from: 0, to: 1),
      total_budget: Faker::Number.between(from: 500, to: 10000),
      user_id: 1
    })

    @trip2 = Trip.create!({
      name: Faker::Name.name,
      location: Faker::Address.country,
      start_date: "Tue, 09 Apr 2024",
      end_date: "Wed, 17 Apr 2024",
      status: Faker::Number.between(from: 0, to: 1),
      total_budget: Faker::Number.between(from: 500, to: 10000),
      user_id: 1
    })

    10.times do
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

    @five_activities = Activity.first(5).each do |activity|
      DailyItinerary.create!(
      trip_id: @trip1.id,
      activity_id: activity.id,
      date: "Tue, 09 Apr 2024",
      time: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :short)
      )
    end
  end

  describe "instance methods" do
    describe "#trip_days" do
      it "returns the number of days a trip will last" do
        expect(@trip1.trip_days).to eq(3)
        expect(@trip2.trip_days).to eq(8)
      end
    end

    describe "#activities_per_day" do
      it "returns the activities of a Trip according to the date" do
        activities = @trip1.activities_per_day("Tue, 09 Apr 2024")

        expect(activities).to eq(@five_activities.sort)

        ten_activities =
          Activity.all.each do |activity|
            DailyItinerary.create!(
            trip_id: @trip1.id,
            activity_id: activity.id,
            date: "Wed, 10 Apr 2024",
            time: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :short)
            )
          end

        expect(@trip1.activities_per_day("Wed, 10 Apr 2024")).to eq(ten_activities)
      end
    end

    describe "#itinerary_per_day" do
      it "returns the day of the trip, and it's activities" do
        itinerary_per_day = @trip1.itinerary_per_day

        expect(itinerary_per_day).to eq({
          "Day 1" => @five_activities,
          "Day 2" => [],
          "Day 3" => []
        })

        seven_activities = Activity.last(8).each do |activity|
          DailyItinerary.create!(
            trip_id: @trip1.id,
            activity_id: activity.id,
            date: "Wed, 10 Apr 2024",
            time: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :short)
            )
        end

        itinerary_per_day2 = @trip1.itinerary_per_day

        expect(itinerary_per_day2).to eq({
          "Day 1" => @five_activities,
          "Day 2" => seven_activities,
          "Day 3" => []
        })

        day_3_activity = DailyItinerary.create!(
          trip_id: @trip1.id,
          activity_id: Activity.last.id,
          date: "Thur, 11 Apr 2024",
          time: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :short)
        )

        itinerary_per_day3 = @trip1.itinerary_per_day

        expect(itinerary_per_day3).to eq({
          "Day 1" => @five_activities,
          "Day 2" => seven_activities,
          "Day 3" => day_3_activity
        })
      end
    end
  end
end
