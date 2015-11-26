class AddFacebookUrLtoEvents < ActiveRecord::Migration
  def change
    add_column :events, :facebook_url, :string
  end
end
