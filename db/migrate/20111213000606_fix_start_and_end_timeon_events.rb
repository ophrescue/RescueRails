class FixStartAndEndTimeonEvents < ActiveRecord::Migration
  def change
    remove_column :events, :start_ts
    remove_column :events, :end_ts
    add_column :events, :start_time, :datetime
    add_column :events, :end_time, :datetime
  end
end
