class Api::V1::TripsController < ApplicationController
   def index
      trips = Trip.where(user_id: params[:user_id])
      render json: TripSerializer.new(trips)
   end

   def show
      trip = Trip.find(params[:id])
      if trip.user_id == params[:user_id].to_i
         render json: TripSerializer.new(trip)
      else
         render_user_error(params)
      end
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

   private

   def trip_params
      params.require(:trip).permit(:name, :location, :start_date, :end_date, :status, :total_budget, :user_id)
   end
end