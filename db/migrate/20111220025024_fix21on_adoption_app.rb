class Fix21onAdoptionApp < ActiveRecord::Migration
  def change
  	remove_column :adoption_apps, :is_21
  	add_column :adoption_apps, :is_ofage, :boolean
  end

end
