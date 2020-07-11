class AddHouseholdAgesToAdoptionApp < ActiveRecord::Migration[5.2]
  def change
    add_column :adoption_apps, :household_ages, :text, array: true, default: []
  end
end
