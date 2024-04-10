class Api::V1::AccommodationsController < ApplicationController
  def update
    accommodation = Accommodation.find(params[:id])
    accommodation.update!(accommodation_params)
    render json: AccommodationSerializer.new(accommodation)
  end

  def create
    accommodation = Accommodation.create!(accommodation_params)
    render json: AccommodationSerializer.new(accommodation), status: :created
  end

  private

  def accommodation_params
    params.require(:accommodation).permit(:trip_id, :name, :address, :check_in, :check_out, :type_of_accommodation, :expenses, :lat, :lon)
  end
end
