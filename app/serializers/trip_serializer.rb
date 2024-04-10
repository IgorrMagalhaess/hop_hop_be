class TripSerializer
  include JSONAPI::Serializer
  attributes :name, :location, :start_date, :end_date, :status, :total_budget
end
