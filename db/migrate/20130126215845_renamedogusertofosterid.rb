class Renamedogusertofosterid < ActiveRecord::Migration
  def up
  	rename_column :dogs, :user_id, :foster_id
  end

  def down
  	rename_column :dogs, :foster_id, :user_id
  end
end
