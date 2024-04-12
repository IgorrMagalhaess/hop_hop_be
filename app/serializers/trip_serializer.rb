class TripSerializer
  include JSONAPI::Serializer
  attributes :name, :location, :start_date, :end_date, :status, :total_budget

  attribute :total_expenses do |object|
    object.activities.sum(&:expenses) || 0
  end

  attribute :daily_itineraries do |object|
    object.daily_itineraries.each_with_object({}) do |day, daily_itineraries|
      daily_itineraries[day.date] = day.activities
    end
  end
end
