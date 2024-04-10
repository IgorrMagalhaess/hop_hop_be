class Trip < ApplicationRecord
   has_many :daily_itineraries
   has_many :activities
   has_many :accomodations


   def trip_days
   end_date - start_date
   end

   def itinerary_per_day
      daily_activities = {}
      day_count = 1
      date = start_date

      while day_count <= trip_days
         day = "Day " + day_count.to_s
         daily_activities[day] = activities_per_day(date)
         day_count = day_count.next
         date = date.next
      end
      daily_activities
   end

   def activities_per_day(date)
      activities.where("date = ?", date)
   end
end
