class MoveDogReqs < ActiveRecord::Migration
  def change
    remove_column :adoption_apps, :dog_reqs
    add_column :adopters, :dog_reqs, :text
  end

end
