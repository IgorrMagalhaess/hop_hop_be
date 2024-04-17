class AccommodationSerializer
  include JSONAPI::Serializer
  attributes :trip_id, :name, :check_in, :check_out, :expenses, :address, :lat, :lon, :type_of_accommodation

  attribute :address_format do |object|
    object.address.titleize
  end
end
