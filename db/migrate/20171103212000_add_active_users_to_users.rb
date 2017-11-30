class AddActiveUsersToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :active, :boolean, default: false, null: false
    # Active users are volunteers contributing to the organization (i.e going to events, working at the shelter, etc).
    # Inactive users are people that have expressed interest in volunteering but are not currently contributing.
    #   Inactive users are unable from viewing any restricted information on the website.
  end
end
