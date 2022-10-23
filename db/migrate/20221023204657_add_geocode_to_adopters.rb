class AddGeocodeToAdopters < ActiveRecord::Migration[6.0]
  def change
    add_column :adopters, :latitude, :float
    add_column :adopters, :longitude, :float
    add_index  :adopters, [:latitude, :longitude]
  end
end
