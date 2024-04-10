class CreateTrips < ActiveRecord::Migration[7.1]
  def change
    create_table :trips do |t|
      t.string :name
      t.string :location
      t.date :start_date
      t.date :end_date
      t.integer :status, default: 0
      t.integer :total_budget

      t.timestamps
    end
  end
end
