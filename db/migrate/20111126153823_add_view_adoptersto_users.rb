class AddViewAdopterstoUsers < ActiveRecord::Migration
  def change
    add_column :users, :view_adopters, :boolean
  end

end
