class AddTripToActivities < ActiveRecord::Migration[7.1]
  def change
    add_reference :activities, :trip, null: false, foreign_key: true
    add_column :accomodations, :name, :string
  end
end
