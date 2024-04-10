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
      "check_in": Time.parse("10:00"),
      "check_out": Time.parse("16:00"),
      "expenses": 1000
    }
  #   {
  #     "id": "1",
  #     "type": "accommodations"
  #     "attributes": {
  #       "name": "Motel 6"
  #       "address": "123 Star Boulevard",
  #       "type_of_accommodation": "Motel",
  #       "lat": "7.8833043",
  #       "lon": "98.3507689",
  #       "check_in": "10:00",
  #       "check_out": "11:00",
  #       "expenses": 2000
  #     }
  # },
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
  end

  #   it 'will not create a new accommodation if missing parameters' do
  #     accommodation_params = {
  #       name: "Visiting Family",
  #       location: "Brazil",
  #       start_date: DateTime.new(2024,12,10),
  #       end_date: DateTime.new(2025,1,10),
  #       total_budget: 10000,
  #       # user_id: 1
  #     }

  #     post '/api/v1/trips', headers: @headers, params: JSON.generate(accommodation: @accommodation_params)

  #     expect(response).to_not be_successful
  #     expect(response.status).to eq(400)

  #     create_response = JSON.parse(response.body, symbolize_names: true)

  #     expect(create_response[:errors]).to be_a(Array)
  #     expect(create_response[:errors].first[:detail]).to eq("Validation failed: User can't be blank")
  #   end

  #   it 'will not create a new accommodation if end_date is earlier than start_date' do
  #     accommodation_params = {
  #       name: "Visiting Family",
  #       location: "Brazil",
  #       start_date: DateTime.new(2025,12,10,12,0,0),
  #       end_date: DateTime.new(2025,1,10),
  #       total_budget: 10000,
  #       user_id: 1
  #     }

  #     post '/api/v1/trips', headers: @headers, params: JSON.generate(accommodation: @accommodation_params)

  #     expect(response).to_not be_successful
  #     expect(response.status).to eq(400)

  #     create_response = JSON.parse(response.body, symbolize_names: true)

  #     expect(create_response[:errors]).to be_a(Array)
  #     expect(create_response[:errors].first[:detail]).to eq("Validation failed: End date must be greater than 2025-12-10 12:00:00 UTC")
  #   end
  # end

  # describe "PATCH /api/v1/trips/:id/accommodations" do
  #   it 'updates accommodation details' do
  #     previous_name = Accommodation.last.name
  #     accommodation_params = { name: 'Different Name' }

  #     patch "/api/v1/trips/#{trip_id}/accommodations", headers: @headers, params: JSON.generate({accommodation: @accommodation_params })

  #     update_response = JSON.parse(response.body, symbolize_names: true)

  #     expect(response).to be_successful
  #     expect(response.status).to eq(200)

  #     accommodation = Trip.find_by(id: trip_id)

  #     expect(accommodation.name).to eq('Different Name')
  #     expect(accommodation.name).to_not eq(previous_name)
  #   end

  #   it 'will raise error if accommodation ID is not found' do
  #     accommodation_params = { name: 'Different Name' }
  #     patch "/api/v1/trips/12323232/accommodations", headers: @headers, params: JSON.generate({accommodation: @accommodation_params })

  #     update_response = JSON.parse(response.body, symbolize_names: true)

  #     expect(response.status).to eq(404)
  #     expect(response).to_not be_successful
  #     expect(update_response[:errors]).to be_a(Array)
  #     expect(update_response[:errors].first[:detail]).to eq("Couldn't find Trip with 'id'=12323232")
  #   end

  #   it 'will raise an error if params are blank' do
  #     patch "/api/v1/trips/#{trip_id}", headers: @headers, params: JSON.generate({accommodation: @accommodation_params })

  #     update_response = JSON.parse(response.body, symbolize_names: true)

  #     expect(response.status).to eq(400)
  #     expect(response).to_not be_successful
  #     expect(update_response[:errors]).to be_a(Array)
  #     expect(update_response[:errors].first[:detail]).to eq("Validation failed: Name can't be blank")
  # end
  # end
end
