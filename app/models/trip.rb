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
         daily_itineraries.find_or_create_by(date: date)
      end
   end

   def dates_changed?
      previous_changes.key?("start_date") || previous_changes.key?("end_date")
   end

   def update_start_date
      return unless previous_changes[:start_date]

      previous_start_date = previous_changes["start_date"][0].to_date
      new_start_date = previous_changes["start_date"][1].to_date

      if previous_start_date > new_start_date
         create_daily_itineraries
      else
         (previous_start_date...new_start_date).each do|date|
            daily_itineraries.destroy_by(date: date)
         end
      end
   end

   def update_end_date
      return unless previous_changes[:end_date]

      previous_end_date = previous_changes["end_date"][0].to_date
      new_end_date = previous_changes["end_date"][1].to_date

      if previous_end_date < new_end_date
         create_daily_itineraries
      else
         (new_end_date...previous_end_date).each do |date|
            daily_itineraries.destroy_by(date: date)
         end
      end
   end

   def update_daily_itineraries
      update_start_date
      update_end_date
   end

end
