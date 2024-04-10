require "rails_helper"

RSpec.describe 'Trips API', type: :request do
   describe 'GET /api/v1/trips' do
      it 'returns a list of trips' do
         trips = create_list(:trip, 5, user_id: 1) 

         get '/api/v1/trips', headers: { "Content-Type" => "application/json", accept => 'application/json' }, params: { user_id: 1 }

         trips_response = JSON.parse(response.body, symbolize_names: true)

         expect(response).to be_successful
         expect(response.status).to eq(200)

         trips = trips_response[:data]

         expect(trips.count).to eq(5)
         expect(trips).to be_a(Array)

         trip = trips.first

         expect(trip).to have_key(:id)
         expect(trip[:id]).to be_a(String)

         expect(trip).to have_key(:type)
         expect(trip[:type]).to eq("trip")

         expect(trip).to have_key(:attributes)
         expect(trip[:attributes]).to be_a(Hash)

         expect(trip[:attributes]).to have_key(:name)
         expect(trip[:attributes][:name]).to be_a(String)

         expect(trip[:attributes]).to have_key(:location)
         expect(trip[:attributes][:location]).to be_a(String)

         expect(trip[:attributes]).to have_key(:start_date)
         expect(trip[:attributes][:start_date]).to be_a(String)

         expect(trip[:attributes]).to have_key(:end_date)
         expect(trip[:attributes][:end_date]).to be_a(String)

         expect(trip[:attributes]).to have_key(:status)
         expect(trip[:attributes][:status]).to be_a(Integer)

         expect(trip[:attributes]).to have_key(:total_budget)
         expect(trip[:attributes][:total_budget]).to be_a(Integer)
      end
   end

   describe 'GET /api/v1/trips/:id' do
      it 'returns a trip details' do
         trip = create(:trip, user_id: 1) 
         
         get "/api/v1/trips/#{trip.id}", headers: { "Content-Type" => "application/json", accept => 'application/json' }, params: { user_id: 1 }

         trip_response = JSON.parse(response.body, symbolize_names: true)

         expect(response).to be_successful
         expect(response.status).to eq(200)

         expect(trip_response).to have_key(:data)
         expect(trip_response[:data]).to be_a(Hash)

         trip = trip_response[:data]

         expect(trip).to have_key(:id)
         expect(trip[:id]).to be_a(String)

         expect(trip).to have_key(:type)
         expect(trip[:type]).to eq("trip")

         expect(trip).to have_key(:attributes)
         expect(trip[:attributes]).to be_a(Hash)

         expect(trip[:attributes]).to have_key(:name)
         expect(trip[:attributes][:name]).to be_a(String)

         expect(trip[:attributes]).to have_key(:location)
         expect(trip[:attributes][:location]).to be_a(String)

         expect(trip[:attributes]).to have_key(:start_date)
         expect(trip[:attributes][:start_date]).to be_a(String)

         expect(trip[:attributes]).to have_key(:end_date)
         expect(trip[:attributes][:end_date]).to be_a(String)

         expect(trip[:attributes]).to have_key(:status)
         expect(trip[:attributes][:status]).to be_a(Integer)

         expect(trip[:attributes]).to have_key(:total_budget)
         expect(trip[:attributes][:total_budget]).to be_a(Integer)
      end

      it 'will return 404 if the trip id is not found' do
         get "/api/v1/trips/123123123", headers: { "Content-Type" => "application/json", accept => 'application/json' }, params: { user_id: 1 }

         trip_response = JSON.parse(response.body, symbolize_names: true)

         expect(response).to_not be_successful
         expect(response.status).to eq(404)
      end
   end
end