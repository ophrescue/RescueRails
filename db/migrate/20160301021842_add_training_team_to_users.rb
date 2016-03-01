class AddTrainingTeamToUsers < ActiveRecord::Migration
  def change
    add_column :users, :training_team, :boolean, default: false
  end
end
