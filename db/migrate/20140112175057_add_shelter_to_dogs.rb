class AddShelterToDogs < ActiveRecord::Migration[4.2]
  def change
    add_column :dogs, :shelter_id, :integer
    add_index :dogs, :shelter_id
  end

end
