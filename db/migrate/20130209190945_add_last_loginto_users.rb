class AddLastLogintoUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :lastlogin, :timestamp
  end

end
