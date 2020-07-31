class AddBuildingTypeToAdoptionApps < ActiveRecord::Migration[5.2]
  def change
    add_column :adoption_apps, :building_type, :string
  end
end
