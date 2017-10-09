class AddSocialMediaToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :social_media_manager, :boolean, default: false, null: false
  end
end
