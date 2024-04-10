class Api::V1::ActivitiesController < ApplicationController
  def index
    activities = Activity.all
    render json: ActivitySerializer.new(activities)
  end

  def create
    trip = Trip.find(params[:trip_id])
    activity = trip.activities.new(activity_params)
    if activity.save!
        render json: ActivitySerializer.new(activity), status: :created
    end
  end

  private

  def activity_params
    params.require(:activity).permit(:address, :description, :lat, :lon, :activity_type, :expenses, :rating, :trip_id)
  end
end
