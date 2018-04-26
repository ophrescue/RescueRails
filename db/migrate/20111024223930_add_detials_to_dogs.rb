class AddDetialsToDogs < ActiveRecord::Migration[4.2]
  def change
    add_column :dogs, :tracking_id, :integer
    add_column :dogs, :primary_breed_id, :integer
    add_column :dogs, :secondary_breed_id, :integer
    add_column :dogs, :status, :string
    add_column :dogs, :age, :string, limit: 75
    add_column :dogs, :size, :string, limit: 75
    add_column :dogs, :is_altered, :boolean
    add_column :dogs, :gender, :string, limit: 6
    add_column :dogs, :is_special_needs, :boolean
    add_column :dogs, :no_dogs, :boolean
    add_column :dogs, :no_cats, :boolean
    add_column :dogs, :no_kids, :boolean
    add_column :dogs, :description, :text

    add_index  :dogs, :primary_breed_id
    add_index  :dogs, :secondary_breed_id
    add_index  :dogs, :age
    add_index  :dogs, :gender
    add_index  :dogs, :size
    add_index  :dogs, :name
  end
end
