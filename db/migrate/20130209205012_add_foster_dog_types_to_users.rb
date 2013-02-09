class AddFosterDogTypesToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :foster_dog_types, :text 
  end
end
