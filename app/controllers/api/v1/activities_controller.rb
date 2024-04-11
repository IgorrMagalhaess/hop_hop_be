class Api::V1::ActivitiesController < ApplicationController
  before_action :trip
  before_action :daily_itinerary
  def index
    activities = Activity.all
    render json: ActivitySerializer.new(activities)
  end

  def create
    activity = daily_itinerary.activities.new(activity_params)
    activity.save!
      render json: ActivitySerializer.new(activity), status: :created
  end

  private

  def activity_params
    params.require(:activity).permit(:name, :address, :description, :lat, :lon, :expenses, :rating, :trip_id)
  end

  def trip
    Trip.find(params[:trip_id])
  end

  def daily_itinerary
    DailyItinerary.find(params[:daily_itinerary_id])
  end
end
