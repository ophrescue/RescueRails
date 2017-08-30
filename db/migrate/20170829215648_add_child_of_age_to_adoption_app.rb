class AddChildOfAgeToAdoptionApp < ActiveRecord::Migration[5.0]
  def change
    add_column :adoption_apps, :child_of_age, :boolean
  end
end
