class AddFosterMentorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :foster_mentor, :boolean, default: false
  end
end
