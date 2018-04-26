class ChangeIsSubscribedToFalse < ActiveRecord::Migration[4.2]
  def change
    change_column :adopters, :is_subscribed, :boolean, default: false
  end

end
