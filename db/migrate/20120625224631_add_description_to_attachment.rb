class AddDescriptionToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :description, :text
  end
end
