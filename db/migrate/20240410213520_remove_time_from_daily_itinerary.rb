class RemoveTimeFromDailyItinerary < ActiveRecord::Migration[7.1]
  def change
    remove_column :daily_itineraries, :time
    add_column :activities, :time, :time
  end
end
