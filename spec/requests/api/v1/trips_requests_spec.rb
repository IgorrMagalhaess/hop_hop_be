require "rails_helper"

RSpec.describe 'Trips API', type: :request do
   describe 'GET /api/v1/trips' do
      it 'returns a list of trips' do
         trips = create_list(:trip, 5, user_id: 1) 

         get '/api/v1/trips', headers: { "Content-Type" => "application/json", accept => 'application/json' }, params: { user_id: 1 }

         trips_response = JSON.parse(response.body, symbolize_names: true)

         expect(response).to be_successful
      end
   end
end