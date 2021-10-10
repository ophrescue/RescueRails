class AddEnergyLevelToDogs < ActiveRecord::Migration[6.0]
  def change
    add_column :dogs, :energy_level, :integer
  end
end
