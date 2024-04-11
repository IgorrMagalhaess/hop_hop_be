class Api::V1::TripsController < ApplicationController
   before_action :set_trip, only: [:show, :update]
   before_action :confirm_user, only: [:show, :update]
   before_action :filter_user_trips, only: [:index]
   
   def index
      render json: TripSerializer.new(@trips)
   end

   def show
      render json: TripSerializer.new(@trip)
   end

   def update
      @trip.update!(trip_params)
      render json: TripSerializer.new(@trip)
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

   def set_trip
      @trip = Trip.find(params[:id])
   end

   def confirm_user
      render_user_error(params) if @trip.user_id != params[:user_id].to_i 
   end

   def filter_user_trips
      @trips = Trip.trips_by_user_id(params[:user_id])
   end
end