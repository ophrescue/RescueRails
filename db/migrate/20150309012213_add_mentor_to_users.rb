class AddMentorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mentor_id, :integer
    add_index :users, :mentor_id
  end
end
