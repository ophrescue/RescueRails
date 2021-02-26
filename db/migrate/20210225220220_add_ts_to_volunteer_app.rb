class AddTsToVolunteerApp < ActiveRecord::Migration[6.0]
  def change
    add_column :volunteer_apps, :created_at, :datetime, null: false
    add_column :volunteer_apps, :updated_at, :datetime, null: false
  end
end
