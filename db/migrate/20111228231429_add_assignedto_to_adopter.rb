class AddAssignedtoToAdopter < ActiveRecord::Migration
  def change
  	add_column :adopters, :assigned_to_user_id, :integer
  end
end
