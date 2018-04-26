class AddFosterDogTypesToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :foster_dog_types, :text
  end
end
