class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.string :name
      t.string :address
      t.string :description
      t.float :lat
      t.float :lon
      t.string :type
      t.integer :expenses
      t.float :rating
      t.references :daily_itinerary, null: false, foreign_key: true

      t.timestamps
    end
  end
end
