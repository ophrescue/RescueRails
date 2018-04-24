class RemoveHousetrainedFromDogs < ActiveRecord::Migration[4.2]
  def change
    remove_column :dogs, :is_housetrained
  end

end
