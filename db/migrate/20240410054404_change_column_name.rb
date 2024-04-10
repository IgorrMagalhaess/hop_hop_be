class ChangeColumnName < ActiveRecord::Migration[7.1]
  def change
    rename_column :activities, :type, :activity_type
    add_column :accomodations, :name, :string
  end
end
