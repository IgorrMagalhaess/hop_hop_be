require 'rails_helper'

RSpec.describe Trip, type: :model do
   describe 'relationships' do
      it { should have_many :daily_itineraries }
      it { should have_many(:activities).through(:daily_itineraries) }
      it { should have_many(:accomodations) }
   end
end