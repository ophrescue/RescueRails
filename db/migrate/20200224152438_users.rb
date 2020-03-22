class Users < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :failed_login_attempts, :integer, default: 0, null: false
  end
end
