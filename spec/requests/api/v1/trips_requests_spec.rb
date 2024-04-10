require "rails_helper"

RSpec.describe 'Trips API', type: :request do
   before do
      @headers = { "Content-Type" => "application/json", accept => 'application/json' }
   end

   describe 'GET /api/v1/trips' do
      it 'returns a list of trips' do
         trips = create_list(:trip, 5, user_id: 1) 

         get '/api/v1/trips', headers: @headers, params: { user_id: 1 }

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
         expect(trip[:attributes][:status]).to be_a(String)

         expect(trip[:attributes]).to have_key(:total_budget)
         expect(trip[:attributes][:total_budget]).to be_a(Integer)
      end
   end

   describe 'GET /api/v1/trips/:id' do
      it 'returns a trip detail' do
         trip = create(:trip, user_id: 1) 
         
         get "/api/v1/trips/#{trip.id}", headers: @headers, params: { user_id: 1 }

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
         expect(trip[:attributes][:status]).to be_a(String)

         expect(trip[:attributes]).to have_key(:total_budget)
         expect(trip[:attributes][:total_budget]).to be_a(Integer)
      end

      it 'will return 404 if the trip id is not found' do
         get "/api/v1/trips/123123123", headers: @headers, params: { user_id: 1 }

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

         patch "/api/v1/trips/#{trip_id}", headers: @headers, params: JSON.generate({trip: trip_params })

         update_response = JSON.parse(response.body, symbolize_names: true)

         expect(response).to be_successful
         expect(response.status).to eq(200)
         
         trip = Trip.find_by(id: trip_id)

         expect(trip.name).to eq('Different Name')
         expect(trip.name).to_not eq(previous_name)
      end

      it 'will raise error if trip ID is not found' do
         trip_params = { name: 'Different Name' }
         patch "/api/v1/trips/12323232", headers: @headers, params: JSON.generate({trip: trip_params })

         update_response = JSON.parse(response.body, symbolize_names: true)

         expect(response.status).to eq(404)
         expect(response).to_not be_successful
         expect(update_response[:errors]).to be_a(Array)
         expect(update_response[:errors].first[:detail]).to eq("Couldn't find Trip with 'id'=12323232")
      end

      it 'will raise an error if params are blank' do
         trip_id = create(:trip, user_id: 1).id
         trip_params = { name: "" }
         patch "/api/v1/trips/#{trip_id}", headers: @headers, params: JSON.generate({trip: trip_params })

         update_response = JSON.parse(response.body, symbolize_names: true)

         expect(response.status).to eq(400)
         expect(response).to_not be_successful
         expect(update_response[:errors]).to be_a(Array)
         expect(update_response[:errors].first[:detail]).to eq("Validation failed: Name can't be blank")
      end
   end

   describe 'POST /api/v1/trips' do
      it 'will create a new trip' do
         trip_params = {
            name: "Visiting Family",
            location: "Brazil",
            start_date: DateTime.new(2024,12,10),
            end_date: DateTime.new(2025,1,10),
            total_budget: 10000,
            user_id: 1
         }

         post '/api/v1/trips', headers: @headers, params: JSON.generate(trip: trip_params)

         created_trip = Trip.last

         expect(response).to be_successful
         expect(response.status).to eq(201)
         
         expect(created_trip.name).to eq(trip_params[:name])
         expect(created_trip.location).to eq(trip_params[:location])
         expect(created_trip.start_date).to eq(trip_params[:start_date])
         expect(created_trip.end_date).to eq(trip_params[:end_date])
         expect(created_trip.status).to eq("in_progress")
         expect(created_trip.total_budget).to eq(trip_params[:total_budget])
         expect(created_trip.user_id).to eq(trip_params[:user_id])
      end
   end
end