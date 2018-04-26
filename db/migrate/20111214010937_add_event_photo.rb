class AddEventPhoto < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :photo_file_name,    :string
  add_column :events, :photo_content_type, :string
  add_column :events, :photo_file_size,    :integer
  add_column :events, :photo_updated_at,   :datetime
  end

end
