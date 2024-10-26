class AddIdToUserBadge < ActiveRecord::Migration[6.1]
  def change
    add_column :badges_users, :id, :primary_key
  end
end
