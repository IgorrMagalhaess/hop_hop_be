class AccomodationSerializer
  include JSONAPI::Serializer
  attributes :trip, :address, :lat, :lon, :type
end
