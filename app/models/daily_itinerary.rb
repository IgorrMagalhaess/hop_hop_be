class DailyItinerary < ApplicationRecord
  belongs_to :trip
  belongs_to :activity

  def self.daily_activities(date)
    DailyItinerary.joins(:activity).where("daily_itineraries.date = ?", date)
  end
end
