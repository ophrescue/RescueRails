class AddActiveUsersToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :active, :boolean, default: false, null: false
    #active user is defined by a volunteer who is working with OPH (i.e going to events, working at the shelter, etc)
    #inactive user is defined by a volunteer who is not but is still considered a volunteer
  end
end
