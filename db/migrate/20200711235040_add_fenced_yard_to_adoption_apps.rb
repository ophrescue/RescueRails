class AddFencedYardToAdoptionApps < ActiveRecord::Migration[5.2]
  def change
    add_column :adoption_apps, :fenced_yard, :boolean
  end
end
