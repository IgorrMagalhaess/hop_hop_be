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
      it { should have_many(:accomodations) }
   end
end