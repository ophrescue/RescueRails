class AddTrainingBoolsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :dog_handling_training_complete, :boolean, null: false, default: false
    add_column :users, :cat_handling_training_complete, :boolean, null: false, default: false
  end
end
