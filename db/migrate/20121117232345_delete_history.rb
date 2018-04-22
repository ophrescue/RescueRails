class DeleteHistory < ActiveRecord::Migration[4.2]
  def change
    remove_column :dogs, :foster_start_date
    drop_table :histories
  end
end
