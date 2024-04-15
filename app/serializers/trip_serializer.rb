class TripSerializer
  include JSONAPI::Serializer
  has_many :daily_itineraries

  attributes :name, :location

  attributes :start_date, :end_date, :status, :total_budget, if: Proc.new {|object, params| params[:index] == false }

  attribute :start_date_format, if: Proc.new { |object, params| params[:index] == false } do |object|
    object.start_date.strftime("%m/%d/%Y")
  end

  attribute :end_date_format, if: Proc.new { |object, params| params[:index] == false } do |object|
    object.end_date.strftime("%m/%d/%Y")
  end

  attribute :total_expenses, if: Proc.new {|object, params| params[:index] == false } do |object|
    object.activities.sum(&:expenses) || 0
  end

  attribute :daily_itineraries, if: Proc.new {|object, params| params[:show] == true} do |object|
    object.daily_itineraries.each_with_object({}) do |day, daily_itineraries|
      daily_itineraries[day.date] = day.activities
    end
  end
end
