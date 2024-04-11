require 'rails_helper'

RSpec.describe Activity, type: :model do
   describe 'relationships' do
      it { should belong_to(:daily_itinerary) }
      it { should have_many(:trip).through(:daily_itinerary) }
      it { should validate_presence_of(:name)}
   end
end
