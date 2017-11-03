class AddVolunteerSupporterToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :volunteer_support, :boolean, default: false, null: false
  end
end
