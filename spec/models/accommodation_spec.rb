require 'rails_helper'

RSpec.describe Accommodation, type: :model do
   describe 'relationships' do
      it { should belong_to :trip }

      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:address) }
   end
end
