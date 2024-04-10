class CreateDailyItineraries < ActiveRecord::Migration[7.1]
  def change
    create_table :daily_itineraries do |t|
      t.references :trip, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true
      t.date :date
      t.time :time

      t.timestamps
    end
  end
end
