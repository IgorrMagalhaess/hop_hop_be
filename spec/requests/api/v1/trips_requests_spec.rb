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

      expect(trip[:attributes]).to have_key(:total_expenses)
      expect(trip[:attributes][:total_expenses]).to be_a(Integer)
    end

    it 'returns only a list of trips for the user passed on the parameters' do
      trips_user_1 = create_list(:trip, 5, user_id: 1)
      trips_user_2 = create_list(:trip, 5, user_id: 2)

      get '/api/v1/trips', headers: @headers, params: { user_id: 1 }

      trips_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      trips = trips_response[:data]

      expect(trips.count).to eq(5)
      expect(trips).to be_a(Array)

      trip_id = trips.first[:id]
      trip_1 = Trip.find(trip_id)

      expect(trip_1.user_id).to eq(1)

      other_trip_id = trips.last[:id]
      other_trip = Trip.find(other_trip_id)

      expect(other_trip.user_id).to_not eq(2)
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

      expect(trip[:attributes]).to have_key(:total_expenses)
      expect(trip[:attributes][:total_expenses]).to be_a(Integer)
    end

    it 'returns a trip detail only if user passed in parameters is the user_id in the trip' do
      trip = create(:trip, user_id: 1)

      get "/api/v1/trips/#{trip.id}", headers: @headers, params: { user_id: 2 }

      trip_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      expect(trip_response).to have_key(:errors)
      expect(trip_response[:errors].first[:detail]).to eq("Validation failed: Invalid User ID provided")
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

      patch "/api/v1/trips/#{trip_id}", headers: @headers, params: JSON.generate({trip: trip_params, user_id: 1 })

      update_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      trip = Trip.last

      expect(trip.name).to eq('Different Name')
      expect(trip.name).to_not eq(previous_name)
    end

    it 'will raise error if trip ID is not found' do
      trip_params = { name: 'Different Name' }
      patch "/api/v1/trips/12323232", headers: @headers, params: JSON.generate({trip: trip_params, user_id: 1 })

      update_response = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(404)
      expect(response).to_not be_successful
      expect(update_response[:errors]).to be_a(Array)
      expect(update_response[:errors].first[:detail]).to eq("Couldn't find Trip with 'id'=12323232")
    end

    it 'will raise an error if params are blank' do
      trip_id = create(:trip, user_id: 1).id
      trip_params = { name: "" }
      patch "/api/v1/trips/#{trip_id}", headers: @headers, params: JSON.generate({trip: trip_params, user_id: 1 })

      update_response = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(response).to_not be_successful
      expect(update_response[:errors]).to be_a(Array)
      expect(update_response[:errors].first[:detail]).to eq("Validation failed: Name can't be blank")
    end

    it 'will raise an error if user_id is not the same as the trip user_id' do
      trip = create(:trip, user_id: 1)

      trip_id = create(:trip, user_id: 1).id
      previous_name = Trip.last.name
      trip_params = { name: 'Different Name' }

      patch "/api/v1/trips/#{trip_id}", headers: @headers, params: JSON.generate({trip: trip_params, user_id: 2 })

      update_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      expect(update_response).to have_key(:errors)
      expect(update_response[:errors].first[:detail]).to eq("Validation failed: Invalid User ID provided")
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

    it 'will not create a new trip if missing parameters' do
      trip_params = {
        name: "Visiting Family",
        location: "Brazil",
        start_date: DateTime.new(2024,12,10),
        end_date: DateTime.new(2025,1,10),
        total_budget: 10000,
        # user_id: 1
      }

      post '/api/v1/trips', headers: @headers, params: JSON.generate(trip: trip_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      create_response = JSON.parse(response.body, symbolize_names: true)

      expect(create_response[:errors]).to be_a(Array)
      expect(create_response[:errors].first[:detail]).to eq("Validation failed: User can't be blank")
    end

    it 'will not create a new trip if end_date is earlier than start_date' do
      trip_params = {
        name: "Visiting Family",
        location: "Brazil",
        start_date: DateTime.new(2025,12,10,12,0,0),
        end_date: DateTime.new(2025,1,10),
        total_budget: 10000,
        user_id: 1
      }

      post '/api/v1/trips', headers: @headers, params: JSON.generate(trip: trip_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      create_response = JSON.parse(response.body, symbolize_names: true)

      expect(create_response[:errors]).to be_a(Array)
      expect(create_response[:errors].first[:detail]).to eq("Validation failed: End date must be greater than 2025-12-10 12:00:00 UTC")
    end
  end

  describe "DELETE /api/v1/trips/:id" do
    it 'will delete a trip' do
      trip = create(:trip, user_id: 1)

      expect(Trip.count).to eq(1)

      delete "/api/v1/trips/#{trip.id}"

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(Trip.count).to eq(0)
    end

    it 'will not delete a trip if id is invalid' do
      delete "/api/v1/trips/123123123"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      delete_response = JSON.parse(response.body, symbolize_names: true)

      expect(delete_response[:errors]).to be_a(Array)
      expect(delete_response[:errors].first[:detail]).to eq("Couldn't find Trip with 'id'=123123123")
    end
  end

  describe "daily_itineraries hash for trip#show" do
    let(:trip) { create(:trip, user_id: 1, start_date: "Thu, 11 Apr 2024", end_date: "Sat, 13 Apr 2024")}

    it "renders a Trip with the daily itinerary date and activities for that date" do
      DailyItinerary.create!(trip_id: trip.id, date: "Thu, 11 Apr 2024")
      DailyItinerary.create!(trip_id: trip.id, date: "Fri, 12 Apr 2024")
      DailyItinerary.create!(trip_id: trip.id, date: "Sat, 13 Apr 2024")
      create_list(:activity, 3, daily_itinerary_id: DailyItinerary.first.id)
      create_list(:activity, 4, daily_itinerary_id: DailyItinerary.second.id)
      create_list(:activity, 6, daily_itinerary_id: DailyItinerary.last.id )

      get "/api/v1/trips/#{trip.id}", headers: @headers, params: { user_id: 1 }

      trip_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(trip_response).to have_key(:data)
      expect(trip_response[:data]).to be_a(Hash)

      trip = trip_response[:data]

      expect(trip[:attributes][:daily_itineraries]).to be_a(Hash)

      trip[:attributes][:daily_itineraries].each do |date , activities|
        expect(date).to be_a(Symbol)
        expect(DateTime.parse(date.to_s)).to be_between("Thu, 11 Apr 2024", "Sat, 13 Apr 2024").inclusive
        expect(activities).to be_an(Array)

        activities.each do |activity|
          expect(activity).to be_a(Hash)
        end
      end
    end

    it "does not render :daily_itineraries for trip#index" do
      DailyItinerary.create!(trip_id: trip.id, date: "Thu, 11 Apr 2024")
      DailyItinerary.create!(trip_id: trip.id, date: "Fri, 12 Apr 2024")
      DailyItinerary.create!(trip_id: trip.id, date: "Sat, 13 Apr 2024")
      create_list(:activity, 3, daily_itinerary_id: DailyItinerary.first.id)
      create_list(:activity, 4, daily_itinerary_id: DailyItinerary.second.id)
      create_list(:activity, 6, daily_itinerary_id: DailyItinerary.last.id )

      get "/api/v1/trips", headers: @headers, params: { user_id: 1 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      trips = JSON.parse(response.body, symbolize_names: true)[:data]

      trips.each do |trip|
        expect(trip[:attributes][:daily_itineraries]).to_not be_present
      end
    end

    it "does not render :daily_itineraries for trip#update" do
      DailyItinerary.create!(trip_id: trip.id, date: "Thu, 11 Apr 2024")
      DailyItinerary.create!(trip_id: trip.id, date: "Fri, 12 Apr 2024")
      DailyItinerary.create!(trip_id: trip.id, date: "Sat, 13 Apr 2024")
      create_list(:activity, 3, daily_itinerary_id: DailyItinerary.first.id)
      create_list(:activity, 4, daily_itinerary_id: DailyItinerary.second.id)
      create_list(:activity, 6, daily_itinerary_id: DailyItinerary.last.id )

      previous_name = Trip.last.name
      trip_params = { name: 'Different Name' }

      patch "/api/v1/trips/#{trip.id}", headers: @headers, params: JSON.generate({trip: trip_params, user_id: 1 })

      updated_trip = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(updated_trip[:data][:attributes][:daily_itineraries]).to_not be_present
    end

    it "does not render :daily_itineraries for trip#create" do
      DailyItinerary.create!(trip_id: trip.id, date: "Thu, 11 Apr 2024")
      DailyItinerary.create!(trip_id: trip.id, date: "Fri, 12 Apr 2024")
      DailyItinerary.create!(trip_id: trip.id, date: "Sat, 13 Apr 2024")
      create_list(:activity, 3, daily_itinerary_id: DailyItinerary.first.id)
      create_list(:activity, 4, daily_itinerary_id: DailyItinerary.second.id)
      create_list(:activity, 6, daily_itinerary_id: DailyItinerary.last.id )

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

      trip = JSON.parse(response.body, symbolize_names: true)

      expect(trip[:data][:attributes][:daily_itineraries]).to_not be_present
    end
  end
end
