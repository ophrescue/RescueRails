class AddActiveToCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :active, :boolean, default: true
  end
end
