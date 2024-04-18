class TripSerializer
  include JSONAPI::Serializer
  has_many :daily_itineraries

  attributes :name, :location, :lat, :lon

  attributes :status, :total_budget, if: Proc.new {|object, params| params[:index] == false }

  attribute :start_date, if: Proc.new { |object, params| params[:index] == false } do |object|
    object.start_date
  end

  attribute :end_date, if: Proc.new { |object, params| params[:index] == false } do |object|
    object.end_date
  end

  attribute :total_expenses, if: Proc.new {|object, params| params[:index] == false } do |object|
    object.activities.sum(:expenses) + object.accommodations.sum(:expenses)
  end

  attribute :daily_itineraries, if: Proc.new {|object, params| params[:show] == true} do |object|
    object.daily_itineraries.includes(:activities).each_with_object({}) do |day, daily_itineraries|
      daily_itineraries[day.date] = day.activities.map{|a| ActivitySerializer.new(a)}
    end
  end
end
