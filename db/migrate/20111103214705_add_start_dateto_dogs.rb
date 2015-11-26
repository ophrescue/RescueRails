class AddStartDatetoDogs < ActiveRecord::Migration
  def change
    add_column :dogs, :foster_start_date, :date
    add_column :dogs, :adoption_date, :date
  end

end
