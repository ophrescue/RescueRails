class AddCampaignIdToDonations < ActiveRecord::Migration[5.2]
  def change
    add_column :donations, :campaign_id, :integer
  end
end
