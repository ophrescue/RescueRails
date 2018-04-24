class AddLocationUrlToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :location_url, :string
    add_column :events, :location_phone, :string
  end
end
