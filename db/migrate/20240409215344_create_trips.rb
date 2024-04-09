class CreateTrips < ActiveRecord::Migration[7.1]
  def change
    create_table :trips do |t|
      t.string :name
      t.string :location
      t.datetime :start_date
      t.datetime :end_date
      t.integer :status
      t.integer :total_budget

      t.timestamps
    end
  end
end
