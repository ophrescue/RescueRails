class AddShelterNametoDogs < ActiveRecord::Migration[4.2]
  def change
    add_column :dogs, :original_name, :string
  end
end
