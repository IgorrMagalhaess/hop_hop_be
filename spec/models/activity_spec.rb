require 'rails_helper'

RSpec.describe Activity, type: :model do
   describe 'relationships' do
      it { should belong_to(:trip) }

      it { should validate_presence_of(:activity_type) }
      it { should validate_presence_of(:address) }
   end
end
