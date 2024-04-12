require 'swagger_helper'

RSpec.describe 'Trips API', type: :request do
  path "/api/v1/trips" do
    get "Finds all trips for a User" do
      tags "Trips"
      consumes 'application/json'
      produces 'application/json'
      description "List all Trips for a User"
      parameter name: :user_id, in: :query, type: :integer
      response(200, 'successful') do
        schema type: :object, properties: {
                                name: {
                                  type: :string,
                                  example: "Disneyland in Tokyo!"
                                },
                                location: {
                                  type: :string,
                                  example: "Tokyo, Japan"
                                },
                              }
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:trip2) { create(:trip, user_id: 1)}
        let(:user_id) { trip1.user_id}
        run_test!
        end
      end
    end
  end
