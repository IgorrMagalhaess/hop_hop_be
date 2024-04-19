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
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:trip_id) { trip1.id }
        let!(:daily_itinerary_id) { daily_itinerary1.id } 

        let!(:activity_1) { create(:activity, daily_itinerary_id: daily_itinerary_id) }
        let!(:activity_2) { create(:activity, daily_itinerary_id: daily_itinerary_id) }
        let!(:activity_3) { create(:activity, daily_itinerary_id: daily_itinerary_id) }

        run_test!
      end

      response(404, "Couldn't find Trip with 'id'=2") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:trip_id) { 2 }
        let!(:daily_itinerary_id) { daily_itinerary1.id } 

        let!(:activity_1) { create(:activity, daily_itinerary_id: daily_itinerary_id) }
        let!(:activity_2) { create(:activity, daily_itinerary_id: daily_itinerary_id) }
        let!(:activity_3) { create(:activity, daily_itinerary_id: daily_itinerary_id) }

        run_test!
      end

      response(404, "Couldn't find Daily Itinerary with 'id'=2") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:trip_id) { trip1.id }
        let!(:daily_itinerary_id) { 2 } 

        let!(:activity_1) { create(:activity, daily_itinerary_id: daily_itinerary1.id) }
        let!(:activity_2) { create(:activity, daily_itinerary_id: daily_itinerary1.id) }
        let!(:activity_3) { create(:activity, daily_itinerary_id: daily_itinerary1.id) }

        run_test!
      end
    end

    post "Create a new Activity" do
      tags "Activities"
      consumes "application/json"
      produces "application/json"
      description "Create a new activity for User's Trip Daily Itinerary with the Activity Information"
      parameter name: :activity, in: :body, schema: { "$ref" => "#/components/schemas/accommodations" }

      response(201, "Activity Created") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:trip_id) { trip1.id }
        let!(:daily_itinerary_id) { daily_itinerary1.id }

        let!(:activity) {
          {
            address: "123 Hope St SE",
            description: "Great swimming pool",
            lat: 20.123123123,
            lon: -23.45644542,
            expenses: 85,
            rating: 2.5,
            name: "Hope Swimming Pool"
          }
        }

        run_test!
      end

      response(400, "Validation failed") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:trip_id) { trip1.id }
        let!(:daily_itinerary_id) { daily_itinerary1.id }

        let!(:activity) {
          {
            address: "123 Hope St SE",
            description: "Great swimming pool",
            lat: 20.123123123,
            lon: -23.45644542,
            expenses: 85,
            rating: 2.5
          }
        }

        run_test!
      end

      response(404, "Couldn't find Trip with 'id'=123123123") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:trip_id) { 123123123 }
        let!(:daily_itinerary_id) { daily_itinerary1.id }

        let!(:activity) {
          {
            address: "123 Hope St SE",
            description: "Great swimming pool",
            lat: 20.123123123,
            lon: -23.45644542,
            expenses: 85,
            rating: 2.5
          }
        }

        run_test!
      end

      response(404, "Couldn't find Daily Itinerary with 'id'=123123123") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:trip_id) { trip1.id }
        let!(:daily_itinerary_id) { 123123123 }

        let!(:activity) {
          {
            address: "123 Hope St SE",
            description: "Great swimming pool",
            lat: 20.123123123,
            lon: -23.45644542,
            expenses: 85,
            rating: 2.5
          }
        }

        run_test!
      end
    end
  end

  path "/api/v1/trips/{trip_id}/daily_itineraries/{daily_itinerary_id}/activities/{activity_id}" do
    parameter name: :trip_id, in: :path, type: :string, description: :trip_id
    parameter name: :daily_itinerary_id, in: :path, type: :string, description: :daily_itinerary_id
    parameter name: :activity_id, in: :path, type: :string, description: :activity_id

    get "Finds one Activity" do
      tags "Activities" 
      consumes "application/json"
      produces "application/json"
      description "Returns all activity details for a given user trip daily itinerary activity"

      response(200, "Successful") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:trip_id) { trip1.id }
        let!(:daily_itinerary_id) { daily_itinerary1.id } 
        let!(:activity_1) { create(:activity, daily_itinerary_id: daily_itinerary_id) }
        let!(:activity_id) { activity_1.id }

        run_test!
      end

      response(404, "Couldn't find Trip with 'id'=123123123") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:trip_id) { 123123123 }
        let!(:daily_itinerary_id) { daily_itinerary1.id } 
        let!(:activity_1) { create(:activity, daily_itinerary_id: daily_itinerary_id) }
        let!(:activity_id) { activity_1.id }

        run_test!
      end

      response(404, "Couldn't find Daily Itinerary with 'id'=123123123") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:trip_id) { trip1.id }
        let!(:daily_itinerary_id) { 123123123 } 
        let!(:activity_1) { create(:activity, daily_itinerary_id: daily_itinerary1.id) }
        let!(:activity_id) { activity_1.id }

        run_test!
      end

      response(404, "Couldn't find Activity with 'id'=123123123") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:trip_id) { trip1.id }
        let!(:daily_itinerary_id) { daily_itinerary1.id } 
        let!(:activity_1) { create(:activity, daily_itinerary_id: daily_itinerary_id) }
        let!(:activity_id) { 123123123 }

        run_test!
      end
    end

    patch "Updates Activity" do
      tags "Activities"
      produces "application/json"
      consumes "application/json"
      description "Updates an activity for the specified trip daily itinerary"
      parameter name: :activity, in: :body, schema: { "$ref" => "#/components/schemas/activity" }

      response(200, "Successful") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:trip_id) { trip1.id }
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:daily_itinerary_id) { daily_itinerary1.id } 
        let!(:activity_1) { create(:activity, daily_itinerary_id: daily_itinerary_id) }
        let!(:activity_id) { activity_1.id }

        let!(:activity) {{name: "Bowling"}}

        run_test!
      end

      response(400, "Validation Failed") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:trip_id) { trip1.id }
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:daily_itinerary_id) { daily_itinerary1.id } 
        let!(:activity_1) { create(:activity, daily_itinerary_id: daily_itinerary_id) }
        let!(:activity_id) { activity_1.id }

        let!(:activity) {{name: ""}}

        run_test!
      end

      response(404, "Couldn't find Activity with 'id'=123123123") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:trip_id) { trip1.id }
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:daily_itinerary_id) { daily_itinerary1.id } 
        let!(:activity_1) { create(:activity, daily_itinerary_id: daily_itinerary_id) }
        let!(:activity_id) { 123123 }

        let!(:activity) {{name: "Bowling"}}

        run_test!
      end

      response(404, "Couldn't find Trip with 'id'=123123123") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:trip_id) { 123123 }
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:daily_itinerary_id) { daily_itinerary1.id } 
        let!(:activity_1) { create(:activity, daily_itinerary_id: daily_itinerary_id) }
        let!(:activity_id) { activity_1.id }

        let!(:activity) {{name: "Bowling"}}

        run_test!
      end

      response(404, "Couldn't find Daily Itinerary with 'id'=123123123") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:trip_id) { trip1.id }
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:daily_itinerary_id) { 123123123 } 
        let!(:activity_1) { create(:activity, daily_itinerary_id: daily_itinerary1.id) }
        let!(:activity_id) { activity_1.id }

        let!(:activity) {{name: "Bowling"}}

        run_test!
      end
    end

    delete "Destroy activity" do
      tags "Activities"
      produces "application/json"
      consumes "application/json"
      description "Delete an activity for the specified trip daily itinerary"

      response(204, "Activity Deleted") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:trip_id) { trip1.id }
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:daily_itinerary_id) { daily_itinerary1.id } 
        let!(:activity_1) { create(:activity, daily_itinerary_id: daily_itinerary1.id) }
        let!(:activity_id) { activity_1.id }

        run_test!
      end

      response(404, "Couldn't find Activity with 'id'=123123123") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:trip_id) { trip1.id }
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:daily_itinerary_id) { daily_itinerary1.id } 
        let!(:activity_1) { create(:activity, daily_itinerary_id: daily_itinerary_id) }
        let!(:activity_id) { 123123 }

        run_test!
      end

      response(404, "Couldn't find Trip with 'id'=123123123") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:trip_id) { 123123 }
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:daily_itinerary_id) { daily_itinerary1.id } 
        let!(:activity_1) { create(:activity, daily_itinerary_id: daily_itinerary_id) }
        let!(:activity_id) { activity_1.id }

        run_test!
      end

      response(404, "Couldn't find Daily Itinerary with 'id'=123123123") do
        let!(:trip1) { create(:trip, user_id: 1)}
        let!(:trip_id) { trip1.id }
        let!(:daily_itinerary1) { trip1.daily_itineraries.first }
        let!(:daily_itinerary_id) { 123123123 } 
        let!(:activity_1) { create(:activity, daily_itinerary_id: daily_itinerary1.id) }
        let!(:activity_id) { activity_1.id }

        run_test!
      end
    end
  end
end
