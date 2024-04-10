class ActivitySerializer
  include JSONAPI::Serializer
  attributes :address, :description, :lat, :lon, :activity_type, :expenses, :rating
end
