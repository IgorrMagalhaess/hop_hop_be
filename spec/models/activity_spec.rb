require 'rails_helper'

RSpec.describe Activity, type: :model do
   describe 'relationships' do
      it { should have_many(:daily_itineraries) }
      it { should have_many(:trips).through(:daily_itineraries) }

      it { should validate_presence_of(:activity_type) }
      it { should validate_presence_of(:address) }
   end
end
