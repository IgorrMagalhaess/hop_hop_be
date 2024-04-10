require 'rails_helper'

RSpec.describe Trip, type: :model do
   describe 'relationships' do
      it { should have_many(:activities) }
      it { should have_many(:accomodations) }
   end

   describe "itinerary_per_day" do
    it "lists the day and activities per that day" do
      trip = create(:trip)

      activities = create_list(:activity, 5, trip_id: trip.id, date: trip.start_date)

      expect(trip.itinerary_per_day).to eq({
        "Day 1" => activities,
        "Day 2" => [],
        "Day 3" => []
      })
    end
   end
end
