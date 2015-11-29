class AddSubscribedToAdopter < ActiveRecord::Migration
  def change
    add_column :adopters, :is_subscribed, :boolean, default: true
  end
end
