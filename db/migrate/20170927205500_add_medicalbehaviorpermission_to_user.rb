class AddMedicalbehaviorpermissionToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :medical_behavior_permission, :boolean, default: false
  end
end
