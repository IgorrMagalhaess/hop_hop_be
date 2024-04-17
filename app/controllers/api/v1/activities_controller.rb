class Api::V1::ActivitiesController < ApplicationController
  before_action :trip
  before_action :daily_itinerary
  def index
    activities = @daily_itinerary.activities.all
    render json: ActivitySerializer.new(activities)
  end

  def show
    activity = @daily_itinerary.activities.find(params[:id])
    render json: ActivitySerializer.new(activity)
  end

  def create
    activity = @daily_itinerary.activities.new(activity_params)
    activity.save!
      render json: ActivitySerializer.new(activity), status: :created
  end

  def update
    activity = @daily_itinerary.activities.find(params[:id])
    activity.update!(activity_params)
    render json: ActivitySerializer.new(activity)
  end

  def destroy
    activity = @daily_itinerary.activities.find(params[:id])
    activity.destroy
    head :no_content, status: :no_content
  end

  private

  def activity_params
    params.require(:activity).permit(:name, :address, :description, :lat, :lon, :expenses, :rating, :trip_id)
  end

  def trip
    @trip = Trip.find(params[:trip_id])
  end

  def daily_itinerary
    @daily_itinerary = @trip.daily_itineraries.find(params[:daily_itinerary_id])
  end
end
