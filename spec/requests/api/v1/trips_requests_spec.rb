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
      it 'returns a trip detail' do
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

         expect(trip_response[:errors].first[:detail]).to eq("Couldn't find Trip with 'id'=123123123")
      end
   end

   describe "PATCH /api/v1/trips/:id" do
      it 'update trip detail' do
         trip_id = create(:trip, user_id: 1).id
         previous_name = Trip.last.name
         trip_params = { name: 'Different Name' }

         patch "/api/v1/trips/#{trip_id}", headers: { "Content-Type" => "application/json", accept => 'application/json' }, params: JSON.generate({trip: trip_params })

         update_response = JSON.parse(response.body, symbolize_names: true)

         expect(response).to be_successful
         expect(response.status).to eq(200)
         
         trip = Trip.find_by(id: trip_id)

         expect(trip.name).to eq('Different Name')
         expect(trip.name).to_not eq(previous_name)
      end

      it 'will raise error if trip ID is not found' do
         trip_params = { name: 'Different Name' }
         patch "/api/v1/trips/12323232", headers: { "Content-Type" => "application/json", accept => 'application/json' }, params: JSON.generate({trip: trip_params })

         update_response = JSON.parse(response.body, symbolize_names: true)

         expect(response.status).to eq(404)
         expect(response).to_not be_successful
         expect(update_response[:errors]).to be_a(Array)
         expect(update_response[:errors].first[:detail]).to eq("Couldn't find Trip with 'id'=12323232")
      end

      it 'will raise an error if params are blank' do
         trip_id = create(:trip, user_id: 1).id
         trip_params = { name: "" }
         patch "/api/v1/trips/#{trip_id}", headers: { "Content-Type" => "application/json", accept => 'application/json' }, params: JSON.generate({trip: trip_params })

         update_response = JSON.parse(response.body, symbolize_names: true)

         expect(response.status).to eq(400)
         expect(response).to_not be_successful
         expect(update_response[:errors]).to be_a(Array)
         expect(update_response[:errors].first[:detail]).to eq("Validation failed: Name can't be blank")
      end
   end
end