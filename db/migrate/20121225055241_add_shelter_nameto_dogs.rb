class AddShelterNametoDogs < ActiveRecord::Migration
  def change
  	add_column :dogs, :original_name, :string
  end
end
