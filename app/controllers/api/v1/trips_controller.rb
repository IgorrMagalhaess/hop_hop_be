class Api::V1::TripsController < ApplicationController
   def index
      trips = Trip.all
      render json: TripSerializer.new(trips)
   end

   def show
      trip = Trip.find(params[:id])
      render json: TripSerializer.new(trip)
   end

   def update
      trip = Trip.find(params[:id])
      trip.update!(trip_params)
      render json: TripSerializer.new(trip)
   end

   def create
      trip = Trip.create!(trip_params)
      render json: TripSerializer.new(trip), status: :created
   end

   def destroy
      trip = Trip.find(params[:id])
      trip.destroy
      head :no_content, status: :no_content
   end

   private

   def trip_params
      params.require(:trip).permit(:name, :location, :start_date, :end_date, :status, :total_budget, :user_id)
   end
end