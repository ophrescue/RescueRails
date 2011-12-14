class ChangeDatetimeInEventAgain < ActiveRecord::Migration
  def change
  	remove_column :events, :start_datetime
  	remove_column :events, :end_datetime
  	add_column :events, :event_date, :date
  	add_column :events, :start_time, :time
  	add_column :events, :end_time, :time
  	add_index :events, :event_date
  end

end
