require 'rails_helper'

RSpec.describe DailyItinerary, type: :model do
   describe 'relationships' do
      it { should belong_to :trip }
      it { should belong_to :activity }
   end
end