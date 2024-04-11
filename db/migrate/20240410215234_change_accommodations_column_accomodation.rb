class ChangeAccommodationsColumnAccomodation < ActiveRecord::Migration[7.1]
  def change
    rename_column :accommodations, :type_of_accomodation, :type_of_accommodation
  end
end
