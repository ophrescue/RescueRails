class AddPhotographerToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :photographer_name, :string
    add_column :events, :photographer_url, :string
  end
end
