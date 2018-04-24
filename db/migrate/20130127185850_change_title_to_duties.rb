class ChangeTitleToDuties < ActiveRecord::Migration[4.2]
  def change
    rename_column :users, :title, :duties
  end

end
