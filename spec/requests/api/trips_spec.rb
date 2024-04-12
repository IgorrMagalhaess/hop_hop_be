require 'swagger_helper'

RSpec.describe 'api/trips', type: :request do
  path "/api/v1/trips" do
    get("List trips")
    require 'pry'; binding.pry
      tags "Trips"
      consumes "application/json"
      produces "application/json"
      description "List all trips for a User"

      response(200, "successful") do
        schema type: :array, items: { "$ref" => "#/components/schemas/trip" }

        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:trip2) { create(:trip, user_id: 1)}

        after do |trip|
          require 'pry'; binding.pry
          trip.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
  end
end
