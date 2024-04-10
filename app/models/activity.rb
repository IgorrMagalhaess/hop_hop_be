class Activity < ApplicationRecord
   has_many :daily_itineraries
   has_many :trips, through: :daily_itineraries
end
