class Trip < ApplicationRecord
   has_many :daily_itineraries
   has_many :activities
   has_many :accomodations
end
