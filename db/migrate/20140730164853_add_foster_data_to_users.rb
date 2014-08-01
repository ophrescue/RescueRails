class AddFosterDataToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :house_type, :string, limit: '40'
  	add_column :users, :breed_restriction, :boolean
  	add_column :users, :weight_restriction, :boolean
  	add_column :users, :has_own_dogs, :boolean
  	add_column :users, :has_own_cats, :boolean
  	add_column :users, :children_under_five, :boolean
  	add_column :users, :has_fenced_yard, :boolean
  	add_column :users, :can_foster_puppies, :boolean
  	add_column :users, :parvo_house, :boolean
  	add_column :users, :admin_comment, :text
  end
end
