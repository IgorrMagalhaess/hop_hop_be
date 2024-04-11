class AddCheckInAndCheckOutToAccomodations < ActiveRecord::Migration[7.1]
  def change
    add_column :accomodations, :check_in, :datetime
    add_column :accomodations, :check_out, :datetime
  end
end
