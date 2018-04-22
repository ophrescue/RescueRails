class AddFacebookUrLtoEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :facebook_url, :string
  end
end
