require "swagger_helper"

RSpec.describe "api/v1/activities", type: :request do

  path "/api/v1/trips/{trip_id}/daily_itineraries/{daily_itinerary_id}/activities" do
    parameter name: :trip_id, in: :path, type: :string, description: :trip_id
    parameter name: :daily_itinerary_id, in: :path, type: :string, description: :daily_itinerary_id

    get "List all activities for a given daily itinerary" do
      tags "Activities"
      consumes "application/json"
      produces "application/json"
      description "List all activities for a given daily itinerary for a given trip"

      response(200, "successful") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:daily_itinerary1) { create(:daily_itinerary, trip}
        let(:trip_id) { trip1.id }
        let(:daily_itinerary_id) { daily_itinerary1.id } 

        let(:activity_1) { create(:activity, daily_itinerary_id: daily_itinerary_id) }
        let(:activity_2) { create(:activity, daily_itinerary_id: daily_itinerary_id) }
        let(:activity_3) { create(:activity, daily_itinerary_id: daily_itinerary_id) }

        run_test!
      end
    end

  #   post("create activity") do
  #     response(200, "successful") do
  #       let(:trip_id) { "123" }
  #       let(:daily_itinerary_id) { "123" }

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           "application/json" => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end
  # end

  # path "/api/v1/trips/{trip_id}/daily_itineraries/{daily_itinerary_id}/activities/{id}" do
  #   # You"ll want to customize the parameter types...
  #   parameter name: "trip_id", in: :path, type: :string, description: "trip_id"
  #   parameter name: "daily_itinerary_id", in: :path, type: :string, description: "daily_itinerary_id"
  #   parameter name: "id", in: :path, type: :string, description: "id"

  #   get("show activity") do
  #     response(200, "successful") do
  #       let(:trip_id) { "123" }
  #       let(:daily_itinerary_id) { "123" }
  #       let(:id) { "123" }

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           "application/json" => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end

  #   patch("update activity") do
  #     response(200, "successful") do
  #       let(:trip_id) { "123" }
  #       let(:daily_itinerary_id) { "123" }
  #       let(:id) { "123" }

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           "application/json" => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end

  #   put("update activity") do
  #     response(200, "successful") do
  #       let(:trip_id) { "123" }
  #       let(:daily_itinerary_id) { "123" }
  #       let(:id) { "123" }

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           "application/json" => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end

  #   delete("delete activity") do
  #     response(200, "successful") do
  #       let(:trip_id) { "123" }
  #       let(:daily_itinerary_id) { "123" }
  #       let(:id) { "123" }

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           "application/json" => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end
  end
end
