class AddFosterMentorToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :foster_mentor, :boolean, default: false
  end
end
