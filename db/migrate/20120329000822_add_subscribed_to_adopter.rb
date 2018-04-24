class AddSubscribedToAdopter < ActiveRecord::Migration[4.2]
  def change
    add_column :adopters, :is_subscribed, :boolean, default: true
  end
end
