require 'swagger_helper'

RSpec.describe 'api/accommodations', type: :request do
  path "/api/v1/trips/{id}/accommodations" do
    parameter name: :id, in: :path, type: :integer
    parameter name: :user_id, in: :query, type: :integer

    post "Create a new accommodation for a trip" do
      tags "Accommodations"
      consumes "application/json"
      produces "application/json"
      description "Create a new accommodation for a trip with all Accommodation information"
      parameter name: :accommodation, in: :body, schema: { "$ref" => "#/components/schemas/accommodations" }

      response(201, 'Accommodation Created') do
        let!(:trip1) { create(:trip, user_id: 1)}
        let(:user_id) { trip1.user_id}
        let(:id) { trip1.id }

        let!(:accommodation){
          {  trip_id: 1,
            name: "Mariott",
            address: "123 Main Street, Phuket, Thailand",
            type_of_accommodation: "Hotel",
            lat: 7.8833121,
            lon: 98.3515484,
            check_in: DateTime.new(2024,12,10,12,0),
            check_out: DateTime.new(2024,12,30,12,0),
            expenses: 1000
          }
        }

        run_test!
      end

      response(400, "Validation failed") do
        let!(:trip1) { create(:trip, user_id: 1) }
        let(:user_id) { trip1.user_id }
        let(:id) { trip1.id }

        let!(:accommodation) {
          {
            trip_id: 1,
            address: "123 Main Street, Phuket, Thailand",
            type_of_accommodation: "Hotel",
            lat: 7.8833121,
            lon: 98.3515484,
            check_in: DateTime.new(2024,12,10,12,0),
            check_out: DateTime.new(2024,12,30,12,0),
            expenses: 1000
          }
        }

        run_test!
      end

      response(404, "Couldn't find Trip with 'id'=123123123") do
        let!(:trip1) { create(:trip, user_id: 1) }
        let(:user_id) { trip1.user_id }
        let(:id) { 123123123 }

        let!(:accommodation) {
          {
            trip_id: 1,
            address: "123 Main Street, Phuket, Thailand",
            type_of_accommodation: "Hotel",
            lat: 7.8833121,
            lon: 98.3515484,
            check_in: DateTime.new(2024,12,10,12,0),
            check_out: DateTime.new(2024,12,30,12,0),
            expenses: 1000
          }
        }

        run_test!
      end
    end
  end

  path "/api/v1/trips/{trip_id}/accommodations/{accommodation_id}" do
    parameter name: :trip_id, in: :path, type: :integer
    parameter name: :accommodation_id, in: :path, type: :integer
    parameter name: :user_id, in: :query, type: :integer

    get "Finds one accomodation" do
      tags "Accomodations"
      consumes "application/json"
      produces "application/json"
      description "Returns all accomodation details for a given trip and user"

      response(200, "Sucessful") do
        let!(:trip1) { create(:trip, user_id: 1) }
        let(:trip_id) { trip1.id }
        let!(:accommodation) { create(:accommodation, trip_id: trip1.id) }
        let(:user_id) { trip1.user_id }
        let(:accommodation_id) { accommodation.id }

        run_test!
      end

      response(404, "Couldn't find Accommodation with 'id'=123123123") do
        let!(:trip1) { create(:trip, user_id: 1) }
        let(:trip_id) { trip1.id }
        let!(:accommodation) { create(:accommodation, trip_id: trip1.id) }
        let(:user_id) { trip1.user_id }
        let(:accommodation_id) { 123123123 }

        run_test!
      end

      response(404, "Couldn't find Trip with 'id'=123123123") do
        let!(:trip1) { create(:trip, user_id: 1) }
        let(:trip_id) { 123123123 }
        let!(:accommodation) { create(:accommodation, trip_id: trip1.id) }
        let(:user_id) { trip1.user_id }
        let(:accommodation_id) { accommodation.id }

        run_test!
      end
    end

    patch "Updates Accommodation for trip" do
      tags "Accommodations"
      produces "application/json"
      consumes "application/json"
      description "Updates a User's Trip Accommodation"
      parameter name: :accomodation, in: :body, schema: { "$ref" => "#/components/schemas/accomodation" }

      response(200, "Accommodation updated") do
        let!(:trip1) { create(:trip, user_id: 1) }
        let(:trip_id) { trip1.id }
        let!(:accommodation1) { create(:accommodation, trip_id: trip1.id) }
        let(:user_id) { trip1.user_id }
        let(:accommodation_id) { accommodation1.id }

        let(:accomodation) {{name: "Hilton Hotel"}}

        run_test!
      end

      response(400, "Validation failed: Name can't be blank") do
        let!(:trip1) { create(:trip, user_id: 1) }
        let(:trip_id) { trip1.id }
        let!(:accommodation1) { create(:accommodation, trip_id: trip1.id) }
        let(:user_id) { trip1.user_id }
        let(:accommodation_id) { accommodation1.id }

        let(:accomodation) {{name: ""}}

        run_test!
      end

      response(404, "Couldn't find Trip with 'id'=123123") do
        let!(:trip1) { create(:trip, user_id: 1) }
        let(:trip_id) { 123123 }
        let!(:accommodation1) { create(:accommodation, trip_id: trip1.id) }
        let(:user_id) { trip1.user_id }
        let(:accommodation_id) { accommodation1.id }

        let(:accomodation) {{name: "Paris 2024 Olympics"}}

        run_test!
      end

      response(404, "Couldn't find Accommodation with 'id'=123123") do
        let!(:trip1) { create(:trip, user_id: 1) }
        let(:trip_id) { trip1.id } 
        let!(:accommodation1) { create(:accommodation, trip_id: trip1.id) }
        let(:user_id) { trip1.user_id }
        let(:accommodation_id) { 123123123 }

        let(:accomodation) {{name: "Paris 2024 Olympics"}}

        run_test!
      end
    end

    delete "Deletes an Accommodation for a trip" do
      tags "Accommodations"
      consumes "application/json"
      produces "application/json"
      description "Deletes an Accommodation for a User's trip"

      response(204, "Accommodation deleted") do
        let!(:trip1) { create(:trip, user_id: 1) }
        let(:trip_id) { trip1.id }
        let!(:accommodation) { create(:accommodation, trip_id: trip1.id) }
        let(:user_id) { trip1.user_id }
        let(:accommodation_id) { accommodation.id }

        run_test!
      end

      response(404, "Couldn't find Trip with 'id'=123123") do
        let!(:trip1) { create(:trip, user_id: 1) }
        let(:trip_id) { 123123 }
        let!(:accommodation) { create(:accommodation, trip_id: trip1.id) }
        let(:user_id) { trip1.user_id }
        let(:accommodation_id) { accommodation.id }

        run_test!
      end

      response(404, "Couldn't find Accommodation with 'id'=123123") do
        let!(:trip1) { create(:trip, user_id: 1) }
        let(:trip_id) { trip1.id }
        let!(:accommodation) { create(:accommodation, trip_id: trip1.id) }
        let(:user_id) { trip1.user_id }
        let(:accommodation_id) { 123123 }

        run_test!
      end
    end
  end
end
