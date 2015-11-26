class RemoveHousetrainedFromDogs < ActiveRecord::Migration
  def change
    remove_column :dogs, :is_housetrained
  end

end
