class DeleteHistory < ActiveRecord::Migration
  def change
    remove_column :dogs, :foster_start_date
    drop_table :histories
  end
end
