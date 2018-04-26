class AddDescriptionToAttachment < ActiveRecord::Migration[4.2]
  def change
    add_column :attachments, :description, :text
  end
end
