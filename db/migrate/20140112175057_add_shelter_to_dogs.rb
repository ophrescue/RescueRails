class AddShelterToDogs < ActiveRecord::Migration
  def change
    add_column :dogs, :shelter_id, :integer
    add_index :dogs, :shelter_id
  end
  
end
