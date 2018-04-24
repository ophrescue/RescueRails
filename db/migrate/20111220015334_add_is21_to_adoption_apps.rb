class AddIs21ToAdoptionApps < ActiveRecord::Migration[4.2]
  def change
    add_column :adoption_apps, :is_ofage, :boolean
  end
end
