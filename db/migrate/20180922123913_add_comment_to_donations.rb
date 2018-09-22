class AddCommentToDonations < ActiveRecord::Migration[5.2]
  def change
    add_column :donations, :comment, :text
  end
end
