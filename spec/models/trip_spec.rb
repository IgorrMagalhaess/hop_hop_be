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
   end
   
   describe 'relationships' do
      it { should have_many :daily_itineraries }
      it { should have_many(:activities).through(:daily_itineraries) }
      it { should have_many(:accomodations) }
   end
end