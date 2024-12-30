class AddTrainingCompletedDatesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :dog_training_completed_dt, :date
    add_column :users, :cat_training_completed_dt, :date
  end
end
