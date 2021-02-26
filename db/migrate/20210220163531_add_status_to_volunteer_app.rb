class AddStatusToVolunteerApp < ActiveRecord::Migration[6.0]
  def change
    add_column :volunteer_apps, :status, :string
  end
end
