class AddFosterDataToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :house_type, :string, limit: '40'
  	add_column :users, :breed_restriction, :boolean, default: false
  	add_column :users, :weight_restriction, :boolean, default: false
  	add_column :users, :max_dog_weight, :integer
  	add_column :users, :has_own_dogs, :boolean, default: false
  	add_column :users, :has_own_cats, :boolean, default: false
  	add_column :users, :children_under_five, :boolean, default: false
  	add_column :users, :has_fenced_yard, :boolean, default: false
  	add_column :users, :can_foster_puppies, :boolean, default: false
  	add_column :users, :parvo_house, :boolean, default: false
  	add_column :users, :admin_comment, :text
  end
end
