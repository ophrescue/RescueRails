class AddCanSharetoUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :share_info, :boolean
  end
end
