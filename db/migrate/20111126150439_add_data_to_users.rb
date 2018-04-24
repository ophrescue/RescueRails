class AddDataToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :phone, 		   :string
    add_column :users, :address1,	   :string
    add_column :users, :address2, 	   :string
    add_column :users, :city, 		   :string
    add_column :users, :state, 		   :string
    add_column :users, :zip, 		   :string
    add_column :users, :title, 		   :string
    add_column :users, :edit_adopters, :boolean
    add_column :users, :edit_dogs, 	   :boolean
  end
end
