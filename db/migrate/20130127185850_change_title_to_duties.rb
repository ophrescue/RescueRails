class ChangeTitleToDuties < ActiveRecord::Migration
  def change
  	rename_column :users, :title, :duties
  end

end
