require 'rails_helper'

RSpec.describe Trip, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:total_budget) }
    it { should validate_presence_of(:user_id) }

    it 'validates that start date cannot be later than end date' do
      trip = Trip.new({
        name: "Visiting Family",
        location: "Brazil",
        start_date: DateTime.new(2025,1,10),
        end_date: DateTime.new(2024,1,10),
        total_budget: 10000,
        user_id: 1
      })
         expect(trip).to_not be_valid
         expect(trip.errors[:end_date]).to include("must be greater than #{trip.start_date}")
      end
   end

   describe 'relationships' do
      it { should have_many :daily_itineraries }
      it { should have_many(:activities).through(:daily_itineraries) }
      it { should have_many(:accommodations) }
   end

   describe ".trips_by_user_id" do
      it "returns trips for a specific user" do
         trips_1 = create_list(:trip, 5, user_id: 1)
         trips_2 = create_list(:trip, 5, user_id: 2)

         expect(Trip.trips_by_user_id(1).count).to eq(5)
         expect(Trip.trips_by_user_id(1).first).to_not eq(trips_2.first)
      end
   end

   describe "when user creates trip with dates" do
      it "create daily_itineraries" do
         trip = Trip.create!({
            name: "Trip To Japan",
            location: "Japan",
            start_date: DateTime.new(2024,5,1),
            end_date: DateTime.new(2024,5,10),
            total_budget: 10000,
            user_id: 2
         })

         expected_days = (DateTime.new(2024,5,1).to_date..DateTime.new(2024,5,10).to_date).count

         expect(trip.daily_itineraries.count).to eq(expected_days)
      end
   end

   describe "create or delete daily_itineraries when edit start_date of the trip" do
      it "deletes daily_itineraries when user changes the start_date to later" do
         trip = Trip.create!({
            name: "Trip To Japan",
            location: "Japan",
            start_date: DateTime.new(2024,5,1),
            end_date: DateTime.new(2024,5,10),
            total_budget: 10000,
            user_id: 2
         })

         trip.update!({
            start_date: DateTime.new(2024,5,3)
         })

         expected_days = (DateTime.new(2024,5,3).to_date..DateTime.new(2024,5,10).to_date).count

         expect(trip.daily_itineraries.count).to eq(expected_days)
      end

      it "creates daily_itineraries when user changes the start_date to earlier" do
         trip = Trip.create!({
            name: "Trip To Japan",
            location: "Japan",
            start_date: DateTime.new(2024,5,1),
            end_date: DateTime.new(2024,5,10),
            total_budget: 10000,
            user_id: 2
         })

         trip.update!({
            start_date: DateTime.new(2024,4,28)
         })

         expected_days = (DateTime.new(2024,4,28).to_date..DateTime.new(2024,5,10).to_date).count

         expect(trip.daily_itineraries.count).to eq(expected_days)
      end
   end

   describe "create or delete daily_itineraries when edit end_date of the trip" do
      it "deletes daily_itineraries when user changes the end_date to earlier" do
         trip = Trip.create!({
            name: "Trip To Japan",
            location: "Japan",
            start_date: DateTime.new(2024,5,1),
            end_date: DateTime.new(2024,5,10),
            total_budget: 10000,
            user_id: 2
         })

         trip.update!({
            end_date: DateTime.new(2024,5,8)
         })

         expected_days = (DateTime.new(2024,5,1).to_date..DateTime.new(2024,5,8).to_date).count
         expect(trip.daily_itineraries.count).to eq(expected_days)
      end

      it "creates daily_itineraries when user changes the end_date to later" do
         trip = Trip.create!({
            name: "Trip To Japan",
            location: "Japan",
            start_date: DateTime.new(2024,5,1),
            end_date: DateTime.new(2024,5,12),
            total_budget: 10000,
            user_id: 2
         })

         trip.update!({
            end_date: DateTime.new(2024,5,12)
         })

         expected_days = (DateTime.new(2024,5,1).to_date..DateTime.new(2024,5,12).to_date).count
         expect(trip.daily_itineraries.count).to eq(expected_days)
      end

      describe "create or delete daily_itineraries when edit both start_date and end_date of the trip" do
         it "creates daily_itineraries when user changes the start_date to earlier and deletes daily_itineraries when user changes the end_date to earlier" do
            trip = Trip.create!({
            name: "Trip To Japan",
            location: "Japan",
            start_date: DateTime.new(2024,5,1),
            end_date: DateTime.new(2024,5,12),
            total_budget: 10000,
            user_id: 2
            })

            trip.update!({
               start_date: DateTime.new(2024,4,28),
               end_date: DateTime.new(2024,5,10)
            })

            expected_days = (DateTime.new(2024,4,28).to_date..DateTime.new(2024,5,10).to_date).count
            expect(trip.daily_itineraries.count).to eq(expected_days)
         end

         it "deletes daily_itineraries when user changes the start_date to later and creates daily_itineraries when user changes the end_date to later" do
            trip = Trip.create!({
            name: "Trip To Japan",
            location: "Japan",
            start_date: DateTime.new(2024,5,1),
            end_date: DateTime.new(2024,5,12),
            total_budget: 10000,
            user_id: 2
            })

            trip.update!({
               start_date: DateTime.new(2024,5,3),
               end_date: DateTime.new(2024,5,15)
            })

            expected_days = (DateTime.new(2024,5,3).to_date..DateTime.new(2024,5,15).to_date).count
            expect(trip.daily_itineraries.count).to eq(expected_days)
         end
      end
   end
end
