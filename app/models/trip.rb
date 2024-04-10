class Trip < ApplicationRecord
   has_many :daily_itineraries
   has_many :activities, through: :daily_itineraries
   has_many :accomodations
end
