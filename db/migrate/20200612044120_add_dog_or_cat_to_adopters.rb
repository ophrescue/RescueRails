class AddDogOrCatToAdopters < ActiveRecord::Migration[5.2]
  def change
    add_column :adopters, :dog_or_cat, :string
  end
end
