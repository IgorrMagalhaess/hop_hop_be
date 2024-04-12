class DailyItinerarySerializer
  include JSONAPI::Serializer
  attributes :trip_id, :date
end
