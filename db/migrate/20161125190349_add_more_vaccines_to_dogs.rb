class AddMoreVaccinesToDogs < ActiveRecord::Migration[5.0]
  def change
    add_column :dogs, :heartworm_preventative, :string
    add_column :dogs, :flea_tick_preventative, :string
  end
end
