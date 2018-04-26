class AddAssignedtoToAdopter < ActiveRecord::Migration[4.2]
  def change
    add_column :adopters, :assigned_to_user_id, :integer
  end
end
