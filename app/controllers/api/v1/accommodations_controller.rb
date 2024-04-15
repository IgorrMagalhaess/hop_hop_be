class Api::V1::AccommodationsController < ApplicationController
  before_action :validate_trip
  def index
    accommodations = @trip.accommodations
    render json: AccommodationSerializer.new(accommodations)
  end

  def show
    accommodation = @trip.accommodations.find(params[:id])
    render json: AccommodationSerializer.new(accommodation)
  end

  def create
    accommodation = @trip.accommodations.create!(accommodation_params)
    render json: AccommodationSerializer.new(accommodation), status: :created
  end

  def update
    accommodation = @trip.accommodations.find(params[:id])
    accommodation.update!(accommodation_params)
    render json: AccommodationSerializer.new(accommodation)
  end

  def destroy
    accommodation = @trip.accommodations.find(params[:id])
    accommodation.destroy
    head :no_content, status: :no_content
  end

  private

  def accommodation_params
    params.require(:accommodation).permit(:trip_id, :name, :address, :check_in, :check_out, :type_of_accommodation, :expenses, :lat, :lon)
  end

  def validate_trip
    @trip = Trip.find(params[:trip_id])
  end
end
