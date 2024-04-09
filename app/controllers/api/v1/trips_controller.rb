class Api::V1::TripsController < ApplicationController
   def index
      trips = Trip.all
      render json: TripsSerializer.new(trips)
   end

   def show
      trip = Trip.find(params[:id])
      render json: TripsSerializer.new(trip)
   end
end