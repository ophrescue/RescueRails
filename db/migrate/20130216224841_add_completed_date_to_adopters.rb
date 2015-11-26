class AddCompletedDateToAdopters < ActiveRecord::Migration
  def change
    add_column :adopters, :completed_date, :date
  end
end
