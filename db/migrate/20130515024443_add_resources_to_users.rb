class AddResourcesToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :dl_resources, :boolean, default: true
  end
end
