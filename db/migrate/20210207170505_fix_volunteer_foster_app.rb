class FixVolunteerFosterApp < ActiveRecord::Migration[6.0]
  def change
    add_column :volunteer_foster_apps, :foster_experience, :text
    remove_column :volunteer_foster_apps, :foster_term
  end
end
