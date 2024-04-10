class Activity < ApplicationRecord
  belongs_to :daily_itinerary
  has_many :trip, through: :daily_itinerary
end
