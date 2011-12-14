class AddLocationUrlToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :location_url, :string
  	add_column :events, :location_phone, :string
  end
end
