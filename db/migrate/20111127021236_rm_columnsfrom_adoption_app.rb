class RmColumnsfromAdoptionApp < ActiveRecord::Migration[4.2]
  def change
    remove_column :adoption_apps, :has_new_dog_exp
    remove_column :adoption_apps, :plan_training
  end
end
