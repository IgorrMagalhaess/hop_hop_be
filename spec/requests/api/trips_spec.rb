require 'swagger_helper'

RSpec.describe 'Trips API', type: :request do

  path "/api/v1/trips" do
    get "Finds all trips for a User" do
      tags "Trips"
      security []
      operationId "findAllTrips"
      consumes 'application/json'
      produces 'application/json'
      description "List all Trips that belong to a user with id, location, and name"
      parameter name: :user_id, in: :query, schema: { "$ref" => "#/components/schemas/all_trips" }

      response(200, 'Successful') do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:trip2) { create(:trip, user_id: 1)}
        let(:user_id) { trip1.user_id}

        run_test!
      end

      response(404, "Couldn't find User with 'id'=2121") do
        schema "$ref" => "#/components/schemas/not_found"

        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:trip2) { create(:trip, user_id: 1)}
        let(:user_id) { 2121 }

        run_test!
      end
    end

    post "Creates a Trip for a User" do
      tags "Trips"
      security []
      operationId "createTrip"
      consumes 'application/json'
      produces 'application/json'
      description "Creates a Trip for a User with all Trip information"
      parameter name: :trip, in: :body

      response(201, 'Trip created') do
        schema "$ref" => "#/components/schemas/trip"
        let!(:trip) {
          {
            name: "Visiting Family",
            location: "Brazil",
            start_date: DateTime.new(2024,12,10),
            end_date: DateTime.new(2025,1,10),
            total_budget: 10000,
            user_id: 1
          }
        }

        run_test!
      end

      response(400, "Validation failed") do
        let(:trip) {
          {
            location: "Brazil",
            start_date: DateTime.new(2024,12,10),
            end_date: DateTime.new(2025,1,10),
            total_budget: 10000,
            user_id: 1
          }
        }

        run_test!
      end
    end
  end

  path "/api/v1/trips/{id}" do
    parameter name: :id, in: :path, type: :integer
    parameter name: :user_id, in: :query, type: :integer

    get "Finds one trip" do
      tags "Trips"
      security []
      operationId "findOneTrip"
      consumes 'application/json'
      produces 'application/json'
      description "List a Trip that belongs to a user with all Trip information and Daily Itineraries"

      response(200, 'Successful') do
        schema "$ref" => "#/components/schemas/trip_show"

        let!(:trip1) { create(:trip, user_id: 1)}
        let(:daily_itinerary) { DailyItinerary.create!(trip_id: trip1.id) }

        let(:user_id) { trip1.user_id}
        let(:id) { trip1.id }
        before do
          create_list(:activity, 5, daily_itinerary_id: daily_itinerary.id)
        end
        run_test!
      end

      response(404, "Couldn't find Trip with 'id'=2") do
        schema "$ref" => "#/components/schemas/not_found"

        let!(:trip1) { create(:trip, user_id: 1)}
        let(:user_id) { trip1.user_id}
        let(:id) { 2 }

        run_test!
      end

      response(400, "Validation failed: Invalid User ID provided") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let(:user_id) { 2 }
        let(:id) { trip1.id }

        run_test!
      end
    end

    patch "Updates a Trip for a User" do
      tags "Trips"
      security []
      operationId "updateTrip"
      produces 'application/json'
      consumes 'application/json'
      description "Updates a User's Trip information"
      parameter name: :trip, in: :body, schema: { "$ref" => "#/components/schemas/trip" }

      response(200, 'Trip updated') do
        let!(:trip1) { create(:trip, user_id: 1)}
        let(:id) { trip1.id }
        let(:user_id) {trip1.user_id}

        let(:trip) {{name: "Disneyland"}}

        run_test!
      end

      response(400, "Validation failed: Name can't be blank") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let(:id) { trip1.id }
        let(:user_id) {trip1.user_id}
        let(:trip) {{name: nil}}

        run_test!
      end

      response(404, "Couldn't find Trip with 'id'=12") do
        schema "$ref" => "#/components/schemas/not_found"

        let!(:trip1) { create(:trip, user_id: 1)}
        let(:id) { 12 }
        let(:user_id) {trip1.user_id}
        let(:trip) {{name: "Paris!"}}

        run_test!
      end
    end

    delete "Deletes a Trip for a User" do
      operationId "deleteTrip"
      tags "Trips"
      security []
      produces 'application/json'
      consumes 'application/json'
      description "Updates a User's Trip information"

      response(204, 'trip deleted') do
        let!(:trip) { create(:trip, user_id: 1)}
        let(:id) { trip.id }
        let(:user_id) {trip.user_id}

        run_test!
      end

      response(404, "Couldn't find Trip with 'id'=12") do
        schema "$ref" => "#/components/schemas/not_found"

        let!(:trip) { create(:trip, user_id: 1)}
        let(:id) { 12 }
        let(:user_id) {trip.user_id}

        run_test!
      end
    end
  end
end
