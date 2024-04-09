class CreateAccomodations < ActiveRecord::Migration[7.1]
  def change
    create_table :accomodations do |t|
      t.references :trip, null: false, foreign_key: true
      t.string :address
      t.float :lat
      t.float :lon
      t.integer :type

      t.timestamps
    end
  end
end
