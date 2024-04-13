class Trip < ApplicationRecord
   has_many :daily_itineraries, dependent: :destroy
   has_many :activities, through: :daily_itineraries, dependent: :destroy
   has_many :accommodations, dependent: :destroy

   validates :name, presence: true
   validates :location, presence: true
   validates :start_date, presence: true
   validates :end_date, presence: true, comparison: { greater_than: :start_date }
   validates :status, presence: true
   validates :total_budget, presence: true
   validates :user_id, presence: true

   enum status: [:in_progress, :completed]

   def self.trips_by_user_id(user_id)
      where(user_id: user_id)
   end
end
