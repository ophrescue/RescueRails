class ChangeIsSubscribedToFalse < ActiveRecord::Migration
  def change
    change_column :adopters, :is_subscribed, :boolean, default: false
  end

end
