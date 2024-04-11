class Api::V1::AccommodationsController < ApplicationController
  before_action :validate_trip

  def show
    accommodation = Accommodation.find(params[:id])
    render json: AccommodationSerializer.new(accommodation)
  end

  def create
    accommodation = Accommodation.create!(accommodation_params)
    render json: AccommodationSerializer.new(accommodation), status: :created
  end

  def update
    accommodation = Accommodation.find(params[:id])
    accommodation.update!(accommodation_params)
    render json: AccommodationSerializer.new(accommodation)
  end

  private

  def accommodation_params
    params.require(:accommodation).permit(:trip_id, :name, :address, :check_in, :check_out, :type_of_accommodation, :expenses, :lat, :lon)
  end

  def validate_trip
    Trip.find(params[:trip_id])
  end
end
