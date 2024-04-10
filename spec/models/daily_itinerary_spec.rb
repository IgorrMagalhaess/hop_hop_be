require 'rails_helper'

RSpec.describe DailyItinerary, type: :model do
   describe 'relationships' do
      it { should belong_to :trip }
      it { should have_many :activities }
   end
end