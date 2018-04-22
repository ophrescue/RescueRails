class AddCompletedDateToAdopters < ActiveRecord::Migration[4.2]
  def change
    add_column :adopters, :completed_date, :date
  end
end
