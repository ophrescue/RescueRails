class AddAdultToVolunteerApp < ActiveRecord::Migration[6.0]
  def change
    add_column :volunteer_apps, :adult, :boolean
  end
end
