require "rails_helper"

RSpec.describe 'Activities API', type: :request do
  before do
    @trip = create(:trip)
  end
  describe 'GET /api/v1/trips/1/activities/' do
    it 'returns a list of activities' do
      activities = create_list(:activity, 5)

      trip_id = @trip.id
      get "/api/v1/trips/#{trip_id}/activities/", headers: { "Content-Type" => "application/json", accept => 'application/json' }

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

      expect(activity[:attributes]).to have_key(:address)
      expect(activity[:attributes][:address]).to be_a(String)

      expect(activity[:attributes]).to have_key(:description)
      expect(activity[:attributes][:description]).to be_a(String)

      expect(activity[:attributes]).to have_key(:lat)
      expect(activity[:attributes][:lat]).to be_a(Float)

      expect(activity[:attributes]).to have_key(:lon)
      expect(activity[:attributes][:lon]).to be_a(Float)

      expect(activity[:attributes]).to have_key(:activity_type)
      expect(activity[:attributes][:activity_type]).to be_a(String)

      expect(activity[:attributes]).to have_key(:expenses)
      expect(activity[:attributes][:expenses]).to be_a(Integer)

      expect(activity[:attributes]).to have_key(:rating)
      expect(activity[:attributes][:rating]).to be_a(Float)
    end
  end

  describe 'POST /api/v1/trips/1/activities/' do
    it 'creates an activity' do
      activities_body = {
        address: Faker::Address.street_address,
        description: Faker::Lorem.paragraph(sentence_count: 2),
        lat: Faker::Address.latitude,
        lon: Faker::Address.longitude,
        activity_type: Faker::Sport.sport(include_ancient: true),
        expenses: Faker::Number.between(from: 0, to: 500),
        rating: Faker::Number.between(from: 2.0, to: 5.0)
      }
      post "/api/v1/trips/#{@trip.id}/activities/", headers: { "Content-Type" => "application/json", accept => 'application/json' }, params: JSON.generate(activities_body)

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

      expect(activity[:attributes]).to have_key(:address)
      expect(activity[:attributes][:address]).to be_a(String)

      expect(activity[:attributes]).to have_key(:description)
      expect(activity[:attributes][:description]).to be_a(String)

      expect(activity[:attributes]).to have_key(:lat)
      expect(activity[:attributes][:lat]).to be_a(Float)

      expect(activity[:attributes]).to have_key(:lon)
      expect(activity[:attributes][:lon]).to be_a(Float)

      expect(activity[:attributes]).to have_key(:activity_type)
      expect(activity[:attributes][:activity_type]).to be_a(String)

      expect(activity[:attributes]).to have_key(:expenses)
      expect(activity[:attributes][:expenses]).to be_a(Integer)

      expect(activity[:attributes]).to have_key(:rating)
      expect(activity[:attributes][:rating]).to be_a(Float)
    end

    it "is missing an activity_type" do
      activities_body = {
        address: Faker::Address.street_address,
        description: Faker::Lorem.paragraph(sentence_count: 2),
        lat: Faker::Address.latitude,
        lon: Faker::Address.longitude,
        expenses: Faker::Number.between(from: 0, to: 500),
        rating: Faker::Number.between(from: 2.0, to: 5.0)
      }
      post "/api/v1/trips/#{@trip.id}/activities/", headers: { "Content-Type" => "application/json", accept => 'application/json' }, params: JSON.generate(activities_body)

      activity_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      expect(activity_response[:errors].first[:detail]).to eq("Validation failed: Activity type can't be blank")
    end

    it "is missing an address" do
      activities_body = {
        activity_type: Faker::Sport.sport(include_ancient: true),
        description: Faker::Lorem.paragraph(sentence_count: 2),
        lat: Faker::Address.latitude,
        lon: Faker::Address.longitude,
        expenses: Faker::Number.between(from: 0, to: 500),
        rating: Faker::Number.between(from: 2.0, to: 5.0)
      }

      post "/api/v1/trips/#{@trip.id}/activities/", headers: { "Content-Type" => "application/json", accept => 'application/json' }, params: JSON.generate(activities_body)

      activity_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      expect(activity_response[:errors].first[:detail]).to eq("Validation failed: Address can't be blank")
    end
  end
end
