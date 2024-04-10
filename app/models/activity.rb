class Activity < ApplicationRecord
   has_many :daily_itineraries
   has_many :trips, through: :daily_itineraries

   validates :activity_type, presence: true
   validates :address, presence: true
end
