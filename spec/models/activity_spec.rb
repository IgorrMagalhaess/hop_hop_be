require 'rails_helper'

RSpec.describe Activity, type: :model do
   describe 'relationships' do
      it { should have_many(:daily_itineraries) }
      it { should have_many(:trips).through(:daily_itineraries) }
   end
end