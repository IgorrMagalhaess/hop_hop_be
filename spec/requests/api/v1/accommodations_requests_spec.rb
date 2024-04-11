require "rails_helper"

RSpec.describe 'Accommodations API', type: :request do
  before do
    @headers = { "Content-Type" => "application/json", accept => 'application/json' }
    @trip = create(:trip, user_id: 1)
    @accommodation_params = {
      "trip_id": @trip.id,
      "name": "Mariott",
      "address": "123 Main Street, Phuket, Thailand",
      "type_of_accommodation": "Hotel",
      "lat": "7.8833043",
      "lon": "98.3507689",
      "check_in": "2024-04-10 10:00:00 UTC",
      "check_out": "2024-04-10 16:00:00 UTC",
      "expenses": 1000
    }
  end

  describe 'POST /api/v1/trips/1/accommodations' do
    it 'will create a new accommodation with correct params' do
      post "/api/v1/trips/#{@trip.id}/accommodations", headers: @headers, params: JSON.generate(accommodation: @accommodation_params)
      accommodation = Accommodation.last

      expect(response).to be_successful
      expect(response.status).to eq(201)

      expect(accommodation.name).to eq("Mariott")
      expect(accommodation.address).to eq("123 Main Street, Phuket, Thailand")
      expect(accommodation.check_in).to eq(@accommodation_params[:check_in])
      expect(accommodation.check_out).to eq(@accommodation_params[:check_out])
      expect(accommodation.type_of_accommodation).to eq("Hotel")
      expect(accommodation.expenses).to eq(1000)
      expect(accommodation.trip_id).to eq(@trip.id)
      expect(accommodation.lat).to eq(7.8833043)
      expect(accommodation.lon).to eq(98.3507689)
    end

    it "renders 404 if trip id doesn't exist" do
      @accommodation_params[:trip_id] = 2

      post "/api/v1/trips/2/accommodations", headers: @headers, params: JSON.generate(accommodation: @accommodation_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      accommodation_response = JSON.parse(response.body, symbolize_names: true)

      expect(accommodation_response[:errors].first[:detail]).to eq("Couldn't find Trip with 'id'=2")
    end

    it 'renders 404 if name is missing parameters' do
      @accommodation_params[:name] = nil
      post "/api/v1/trips/#{@trip.id}/accommodations", headers: @headers, params: JSON.generate(accommodation: @accommodation_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      create_response = JSON.parse(response.body, symbolize_names: true)

      expect(create_response[:errors]).to be_a(Array)
      expect(create_response[:errors].first[:detail]).to eq("Validation failed: Name can't be blank")
    end

    it 'renders 404 if address is missing parameters' do
      @accommodation_params[:address] = nil
      post "/api/v1/trips/#{@trip.id}/accommodations", headers: @headers, params: JSON.generate(accommodation: @accommodation_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      create_response = JSON.parse(response.body, symbolize_names: true)

      expect(create_response[:errors]).to be_a(Array)
      expect(create_response[:errors].first[:detail]).to eq("Validation failed: Address can't be blank")
    end

    it 'renders 400 if check in is after check out' do
      @accommodation_params[:check_in] = Time.parse("16:00")
      post "/api/v1/trips/#{@trip.id}/accommodations", headers: @headers, params: JSON.generate(accommodation: @accommodation_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      create_response = JSON.parse(response.body, symbolize_names: true)

      expect(create_response[:errors]).to be_a(Array)
      expect(create_response[:errors].first[:detail]).to eq("Validation failed: Check out must be greater than 2024-04-10 23:00:00 UTC")
    end
  end


  describe "PATCH /api/v1/trips/1/accommodations:id" do
    it "will update an accommodation successfully" do
      accommodation = Accommodation.create(@accommodation_params)
      params = { address: "1234567 Mario Kart" }

      patch "/api/v1/trips/#{@trip.id}/accommodations/#{accommodation.id}", headers: @headers, params: JSON.generate(params)


      expect(response).to be_successful
      expect(response.status).to eq(200)

      accommodation = Accommodation.find_by(trip_id: @trip.id)

      expect(accommodation.address).to eq('1234567 Mario Kart')
      expect(accommodation.address).to_not eq("123 Main Street, Phuket, Thailand")
    end

    it "renders 404 if accommodation id doesn't exist" do
      params = { address: "1234567 Mario Kart" }

      patch "/api/v1/trips/#{@trip.id}/accommodations/2", headers: @headers, params: JSON.generate(params)


      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Accommodation with 'id'=2")
    end

    it "renders 404 if trip id doesn't exist" do
      accommodation = Accommodation.create(@accommodation_params)

      params = { address: "1234567 Mario Kart" }

      patch "/api/v1/trips/2/accommodations/#{accommodation.id}", headers: @headers, params: JSON.generate(params)


      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Trip with 'id'=2")
    end

    it "renders 400 if name is blank" do
      accommodation = Accommodation.create(@accommodation_params)

      params = { name: nil }

      patch "/api/v1/trips/#{@trip.id}/accommodations/#{accommodation.id}", headers: @headers, params: JSON.generate(params)


      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Validation failed: Name can't be blank")
    end

    it "renders 400 if address is blank" do
      accommodation = Accommodation.create(@accommodation_params)

      params = { address: nil }

      patch "/api/v1/trips/#{@trip.id}/accommodations/#{accommodation.id}", headers: @headers, params: JSON.generate(params)


      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Validation failed: Address can't be blank")
    end

    it "renders 400 if check out is before check in" do
      accommodation = Accommodation.create(@accommodation_params)

      params = { check_out: "2023-04-10 10:00:00 UTC"}

      patch "/api/v1/trips/#{@trip.id}/accommodations/#{accommodation.id}", headers: @headers, params: JSON.generate(params)


      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Validation failed: Check out must be greater than 2024-04-10 10:00:00 UTC")
    end
  end
end
