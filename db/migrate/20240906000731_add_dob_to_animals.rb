class AddDobToAnimals < ActiveRecord::Migration[6.1]
  def change
    add_column :dogs, :birth_dt, :date
    add_column :cats, :birth_dt, :date
  end
end
