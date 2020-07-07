class AddPrevCurrentPetTypesToAdoptionApp < ActiveRecord::Migration[5.2]
  def change
    add_column :adoption_apps, :prev_pets_type, :string
    add_column :adoption_apps, :current_pets_type, :string
  end
end
