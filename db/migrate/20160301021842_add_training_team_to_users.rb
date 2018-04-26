class AddTrainingTeamToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :training_team, :boolean, default: false
  end
end
