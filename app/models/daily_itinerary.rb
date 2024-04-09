class DailyItinerary < ApplicationRecord
  belongs_to :trip
  belongs_to :activity
end
