class AddUserIdToDog < ActiveRecord::Migration[4.2]
  def change
    add_column :dogs, :user_id, :integer
    add_index :dogs, :user_id
  end
end
