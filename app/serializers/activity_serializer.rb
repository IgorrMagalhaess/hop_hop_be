class ActivitySerializer
  include JSONAPI::Serializer
  attributes :address, :description, :lat, :lon, :expenses, :rating, :name
  attribute :daily_itinerary_date_format do |object|
    object.daily_itinerary.date.strftime("%m/%d/%Y")
  end
end
