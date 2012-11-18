class AddMedicalToDogs < ActiveRecord::Migration
  def change
  	add_column :dogs, :first_shots, :string
  	add_column :dogs, :second_shots, :string
  	add_column :dogs, :third_shots, :string
  	add_column :dogs, :rabies, :string
  	add_column :dogs, :heartworm, :string
  	add_column :dogs, :bordetella, :string
  	add_column :dogs, :microchip, :string
  end
end
