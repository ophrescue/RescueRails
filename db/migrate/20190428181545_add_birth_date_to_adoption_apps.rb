class AddBirthDateToAdoptionApps < ActiveRecord::Migration[5.2]
  def change
    add_column :adoption_apps, :birth_date, :date
  end
end
