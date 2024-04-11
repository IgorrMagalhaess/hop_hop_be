class AddExpensesToAccommodations < ActiveRecord::Migration[7.1]
  def change
    add_column :accommodations, :expenses, :integer
  end
end
