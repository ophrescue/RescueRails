class AddMoreFlagsToDogs < ActiveRecord::Migration[5.2]
  def change
    add_column :dogs, :no_urban_setting, :boolean, null: false, default: false
    add_column :dogs, :home_check_required, :boolean, null: false, default: false
  end
end
