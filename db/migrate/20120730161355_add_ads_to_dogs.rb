class AddAdsToDogs < ActiveRecord::Migration[4.2]
  def change
    add_column :dogs, :petfinder_ad_url, :string
    add_column :dogs, :adoptapet_ad_url, :string
    add_column :dogs, :craigslist_ad_url, :string
    add_column :dogs, :youtube_video_url, :string
  end
end
