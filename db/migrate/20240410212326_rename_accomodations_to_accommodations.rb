class RenameAccomodationsToAccommodations < ActiveRecord::Migration[7.1]
  def change
    rename_table :accomodations, :accommodations
  end
end
