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

   after_create_commit :create_daily_itineraries
   after_update_commit :update_daily_itineraries, if: :dates_changed?
   enum status: [:in_progress, :completed]

   def self.trips_by_user_id(user_id)
      where(user_id: user_id)
   end

   private
   def create_daily_itineraries
      (start_date.to_date..end_date.to_date).each do |date|
         daily_itineraries.create!(date: date)
      end
   end


end
