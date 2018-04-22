class AddNewFieldsToDogs < ActiveRecord::Migration[4.2]
  def change
    remove_column :dogs, :is_purebred
    add_column :dogs, :is_uptodateonshots, :boolean, default: true
    add_column :dogs, :is_housetrained, :boolean, default: true
    add_column :dogs, :intake_dt, :date
    add_column :dogs, :available_on_dt, :date
  end
end
