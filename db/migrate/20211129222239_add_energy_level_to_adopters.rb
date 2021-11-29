class AddEnergyLevelToAdopters< ActiveRecord::Migration[6.0]
  def change
    add_column :adopters, :energy_level, :integer
  end
end
