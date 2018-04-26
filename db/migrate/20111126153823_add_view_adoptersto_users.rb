class AddViewAdopterstoUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :view_adopters, :boolean
  end

end
