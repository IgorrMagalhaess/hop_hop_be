require 'rails_helper'

RSpec.describe Accomodation, type: :model do
   describe 'relationships' do
      it { should belong_to :trip }
   end
end