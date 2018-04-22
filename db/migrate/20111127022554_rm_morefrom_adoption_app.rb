class RmMorefromAdoptionApp < ActiveRecord::Migration[4.2]
  def change
    remove_column :adoption_apps, :has_yard
    remove_column :adoption_apps, :has_fence
    remove_column :adoption_apps, :has_parks
    remove_column :adoption_apps, :dog_at_night
    remove_column :adoption_apps, :current_pets_fixed
    add_column :adoption_apps, :current_pets_fixed, :boolean
    remove_column :adoption_apps, :rent_deposit
    remove_column :adoption_apps, :rent_increase
    add_column :adoption_apps, :rent_costs, :text
    remove_column :adoption_apps, :why_adopt
    add_column :adopters, :why_adopt, :text
  end
end
