require 'rails_helper'

RSpec.describe Trip, type: :model do
   describe 'relationships' do
      it { should have_many(:activities) }
      it { should have_many(:accomodations) }
   end
end
