class AddIndexesForForeignKeys < ActiveRecord::Migration
  def change
    add_index :adopters, :assigned_to_user_id
    add_index :comments, :commentable_id
    add_index :comments, :user_id
    add_index :dogs, :coordinator_id
  end
end
