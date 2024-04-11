require "rails_helper"

RSpec.describe "Activities API", type: :request do
  before do
    @headers = { "Content-Type" => "application/json", accept => 'application/json' }
  end

  describe "/api/v1/trips/:id/daily_itineraries/:id/activities/" do
    let(:trip) { create(:trip, user_id: 1) }
    let(:daily_itinerary) { DailyItinerary.create!(trip_id: trip.id, date: trip.start_date) }
    let!(:activities) do
      create_list(:activity, 5, daily_itinerary_id: daily_itinerary.id)
    end

    it "returns all activities for an itinerary" do
      get "/api/v1/trips/#{trip.id}/daily_itineraries/#{daily_itinerary.id}/activities/"

      activities_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      activities = activities_response[:data]

      expect(activities.count).to eq(5)
      expect(activities).to be_a(Array)

      activity = activities.first

      expect(activity).to have_key(:id)
      expect(activity[:id]).to be_a(String)

      expect(activity).to have_key(:type)
      expect(activity[:type]).to eq("activity")

      expect(activity).to have_key(:attributes)
      expect(activity[:attributes]).to be_a(Hash)

      expect(activity[:attributes]).to have_key(:name)
      expect(activity[:attributes][:name]).to be_a(String)

      expect(activity[:attributes]).to have_key(:address)
      expect(activity[:attributes][:address]).to be_a(String)

      expect(activity[:attributes]).to have_key(:description)
      expect(activity[:attributes][:description]).to be_a(String)

      expect(activity[:attributes]).to have_key(:lat)
      expect(activity[:attributes][:lat]).to be_a(Float)

      expect(activity[:attributes]).to have_key(:lon)
      expect(activity[:attributes][:lon]).to be_a(Float)

      expect(activity[:attributes]).to have_key(:expenses)
      expect(activity[:attributes][:expenses]).to be_a(Integer)

      expect(activity[:attributes]).to have_key(:rating)
      expect(activity[:attributes][:rating]).to be_a(Float)
    end
  end

  describe "POST /api/v1/daily_itineraries/#{@daily_itinerary1}/activities/" do
    let(:trip) { create(:trip, user_id: 1) }
    let(:daily_itinerary) { DailyItinerary.create!(trip_id: trip.id, date: trip.start_date) }

    it "creates an activity" do
      expect(Activity.count).to eq(0)

      activities_body = {
        address: Faker::Address.street_address,
        description: Faker::Lorem.paragraph(sentence_count: 2),
        lat: Faker::Address.latitude,
        lon: Faker::Address.longitude,
        name: Faker::Sport.sport(include_ancient: true),
        expenses: Faker::Number.between(from: 0, to: 500),
        rating: Faker::Number.between(from: 2.0, to: 5.0)
      }

      post "/api/v1/trips/#{trip.id}/daily_itineraries/#{daily_itinerary.id}/activities/", headers: @headers, params: JSON.generate(activities_body)

      activity_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(201)

      expect(activity_response).to have_key(:data)
      expect(activity_response[:data]).to be_a(Hash)

      activity = activity_response[:data]

      expect(activity).to have_key(:id)
      expect(activity[:id]).to be_a(String)

      expect(activity).to have_key(:type)
      expect(activity[:type]).to eq("activity")

      expect(activity).to have_key(:attributes)
      expect(activity[:attributes]).to be_a(Hash)

      expect(activity[:attributes]).to have_key(:name)
      expect(activity[:attributes][:name]).to be_a(String)

      expect(activity[:attributes]).to have_key(:address)
      expect(activity[:attributes][:address]).to be_a(String)

      expect(activity[:attributes]).to have_key(:description)
      expect(activity[:attributes][:description]).to be_a(String)

      expect(activity[:attributes]).to have_key(:lat)
      expect(activity[:attributes][:lat]).to be_a(Float)

      expect(activity[:attributes]).to have_key(:lon)
      expect(activity[:attributes][:lon]).to be_a(Float)

      expect(activity[:attributes]).to have_key(:expenses)
      expect(activity[:attributes][:expenses]).to be_a(Integer)

      expect(activity[:attributes]).to have_key(:rating)
      expect(activity[:attributes][:rating]).to be_a(Float)
    end

    it "renders 400 when missing name" do
      activities_body = {
        address: Faker::Address.street_address,
        description: Faker::Lorem.paragraph(sentence_count: 2),
        lat: Faker::Address.latitude,
        lon: Faker::Address.longitude,
        expenses: Faker::Number.between(from: 0, to: 500),
        rating: Faker::Number.between(from: 2.0, to: 5.0)
      }

      post "/api/v1/trips/#{trip.id}/daily_itineraries/#{daily_itinerary.id}/activities/", headers: @headers, params: JSON.generate(activities_body)

      activity_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      expect(activity_response[:errors].first[:detail]).to eq("Validation failed: Name can't be blank")
    end

    # it "is missing an address" do
    #   activities_body = {
    #     name: Faker::Sport.sport(include_ancient: true),
    #     description: Faker::Lorem.paragraph(sentence_count: 2),
    #     lat: Faker::Address.latitude,
    #     lon: Faker::Address.longitude,
    #     expenses: Faker::Number.between(from: 0, to: 500),
    #     rating: Faker::Number.between(from: 2.0, to: 5.0)
    #   }

    #   post "/api/v1/trips/#{trip.id}/daily_itineraries/#{daily_itinerary.id}/activities/", headers: @headers, params: JSON.generate(activities_body)

    #   activity_response = JSON.parse(response.body, symbolize_names: true)

    #   expect(response).to_not be_successful
    #   expect(response.status).to eq(400)

    #   expect(activity_response[:errors].first[:detail]).to eq("Validation failed: Address can't be blank")
    # end

    it "tries to create an activity for a trip that doesn't exist" do
      activities_body = {
        name: Faker::Sport.sport(include_ancient: true),
        address: Faker::Address.street_address,
        description: Faker::Lorem.paragraph(sentence_count: 2),
        lat: Faker::Address.latitude,
        lon: Faker::Address.longitude,
        expenses: Faker::Number.between(from: 0, to: 500),
        rating: Faker::Number.between(from: 2.0, to: 5.0)
      }

      post "/api/v1/trips/3/daily_itineraries/#{daily_itinerary.id}/activities/", headers: @headers, params: JSON.generate(activities_body)

      activity_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      expect(activity_response[:errors].first[:detail]).to eq("Couldn't find Trip with 'id'=3")
    end

    it "tries to create an activity for a DailyItinerary that doesn't exist" do
      activities_body = {
        name: Faker::Sport.sport(include_ancient: true),
        address: Faker::Address.street_address,
        description: Faker::Lorem.paragraph(sentence_count: 2),
        lat: Faker::Address.latitude,
        lon: Faker::Address.longitude,
        expenses: Faker::Number.between(from: 0, to: 500),
        rating: Faker::Number.between(from: 2.0, to: 5.0)
      }

      post "/api/v1/trips/#{trip.id}/daily_itineraries/3/activities/", headers: @headers, params: JSON.generate(activities_body)

      activity_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      expect(activity_response[:errors].first[:detail]).to eq("Couldn't find DailyItinerary with 'id'=3")
    end
  end

  describe "PATCH Activity" do
    let(:trip) { create(:trip, user_id: 1) }
    let(:daily_itinerary) { DailyItinerary.create!(trip_id: trip.id, date: trip.start_date) }
    let(:activity) {create(:activity, daily_itinerary_id: daily_itinerary.id)}

    it "renders 200 when successful" do
      params = { name: "Lunch" }

      patch "/api/v1/trips/#{trip.id}/daily_itineraries/#{daily_itinerary.id}/activities/#{activity.id}", headers: @headers, params: JSON.generate(params)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      edited_activity = Activity.find_by(daily_itinerary_id: daily_itinerary.id)


      expect(edited_activity.name).to eq("Lunch")
      expect(edited_activity.name).to_not eq(activity.name)
    end

    it "renders 404 when daily_itinerary id doesn't exist" do
      params = { name: "Lunch" }

      patch "/api/v1/trips/#{trip.id}/daily_itineraries/100/activities/#{activity.id}", headers: @headers, params: JSON.generate(params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find DailyItinerary with 'id'=100")
    end

    it "renders 404 when trip id doesn't exist" do
      params = { name: "Lunch" }

      patch "/api/v1/trips/100/daily_itineraries/#{daily_itinerary.id}/activities/#{activity.id}", headers: @headers, params: JSON.generate(params)


      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Trip with 'id'=100")
    end

    it "renders 404 when activity id doesn't exist" do
      params = { name: "Lunch" }

      patch "/api/v1/trips/#{trip.id}/daily_itineraries/#{daily_itinerary.id}/activities/100", headers: @headers, params: JSON.generate(params)


      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Activity with 'id'=100")
    end

    it "renders 400 when name is blank" do
      params = { name: nil }

      patch "/api/v1/trips/#{trip.id}/daily_itineraries/#{daily_itinerary.id}/activities/#{activity.id}", headers: @headers, params: JSON.generate(params)

      activity_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      expect(activity_response[:errors].first[:detail]).to eq("Validation failed: Name can't be blank")
    end
  end

  describe "DESTROY Activity" do
    let(:trip) { create(:trip, user_id: 1) }
    let(:daily_itinerary) { DailyItinerary.create!(trip_id: trip.id, date: trip.start_date) }
    let(:activity) {create(:activity, daily_itinerary_id: daily_itinerary.id)}

    it "renders  204 if successful" do
      activity
      expect(Activity.count).to eq(1)

      delete "/api/v1/trips/#{trip.id}/daily_itineraries/#{daily_itinerary.id}/activities/#{activity.id}"

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(Activity.count).to eq(0)
    end

    it 'renders 404 if trip id is invalid' do
      delete "/api/v1/trips/200/daily_itineraries/#{daily_itinerary.id}/activities/#{activity.id}"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      delete_response = JSON.parse(response.body, symbolize_names: true)

      expect(delete_response[:errors]).to be_a(Array)
      expect(delete_response[:errors].first[:detail]).to eq("Couldn't find Trip with 'id'=200")
    end

    it "renders 404 if activity id is invalid" do
      delete "/api/v1/trips/#{trip.id}/daily_itineraries/#{daily_itinerary.id}/activities/55"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      delete_response = JSON.parse(response.body, symbolize_names: true)

      expect(delete_response[:errors]).to be_a(Array)
      expect(delete_response[:errors].first[:detail]).to eq("Couldn't find Activity with 'id'=55")
    end

    it "renders 404 if daily_itinerary id is invalid" do
      delete "/api/v1/trips/#{trip.id}/daily_itineraries/55/activities/#{activity.id}"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      delete_response = JSON.parse(response.body, symbolize_names: true)

      expect(delete_response[:errors]).to be_a(Array)
      expect(delete_response[:errors].first[:detail]).to eq("Couldn't find DailyItinerary with 'id'=55")
    end
  end
end
