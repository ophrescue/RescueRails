class Addavatartousers < ActiveRecord::Migration[5.2]
  def change
    add_attachment :users, :avatar
  end
end
