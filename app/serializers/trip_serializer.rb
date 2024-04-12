class TripSerializer
  include JSONAPI::Serializer
  attributes :name, :location, :start_date, :end_date, :status, :total_budget

  has_many :daily_itineraries
  has_many :activities, through: :daily_itineraries

  attribute :total_expenses do |object|
    object.activities.sum(&:expenses) || 0
  end
end
