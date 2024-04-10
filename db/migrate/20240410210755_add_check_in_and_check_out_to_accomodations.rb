class AddCheckInAndCheckOutToAccomodations < ActiveRecord::Migration[7.1]
  def change
    add_column :accomodations, :check_in, :time
    add_column :accomodations, :check_out, :time
  end
end
