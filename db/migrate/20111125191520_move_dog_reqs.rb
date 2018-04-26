class MoveDogReqs < ActiveRecord::Migration[4.2]
  def change
    remove_column :adoption_apps, :dog_reqs
    add_column :adopters, :dog_reqs, :text
  end

end
