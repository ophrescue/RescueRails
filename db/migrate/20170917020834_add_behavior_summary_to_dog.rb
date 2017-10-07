class AddBehaviorSummaryToDog < ActiveRecord::Migration[5.0]
  def change
    add_column  :dogs, :behavior_summary, :text
  end
end
