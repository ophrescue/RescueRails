class ChangeWritingToMarketing < ActiveRecord::Migration[6.0]
  def change
    remove_column :volunteer_apps, :writing_interest
    add_column :volunteer_apps, :marketing_interest, :boolean
  end
end
