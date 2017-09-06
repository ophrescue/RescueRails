class AddHasFamilyUnder18ToAdoptionApp < ActiveRecord::Migration[5.0]
  def change
    add_column :adoption_apps, :has_family_under_18, :boolean, null: false, default: false
  end
end
