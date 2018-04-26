class RmOldPetsfromAdoptionApp < ActiveRecord::Migration[4.2]
  def change
    remove_column :adoption_apps, :prior_pets
    remove_column :adoption_apps, :vet_name
    remove_column :adoption_apps, :vet_phone
    add_column :adoption_apps, :vet_info, :text
  end

end
