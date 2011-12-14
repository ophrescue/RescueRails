class Changeeventsdatetimeagain < ActiveRecord::Migration
  def change
  	remove_column :events, :start_time
  	remove_column :events, :end_time
  	add_column :events, :start_datetime, :datetime
  	add_column :events, :end_datetime, :datetime
  end
end
