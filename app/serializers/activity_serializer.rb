class ActivitySerializer
  include JSONAPI::Serializer
  attributes :address, :description, :lat, :lon, :expenses, :rating, :name
end
