class AddResourcesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dl_resources, :boolean, default: true
  end
end
