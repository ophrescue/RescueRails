class AddMoreFlagsToCats < ActiveRecord::Migration[5.2]
  def change
    add_column :cats, :no_urban_setting, :boolean, null: false, default: false
    add_column :cats, :home_check_required, :boolean, null: false, default: false
  end
end
