class AddVerifyHomeAuthToAdoptionApp < ActiveRecord::Migration[5.0]
  def change
    add_column :adoption_apps, :verify_home_auth, :boolean, default: false
  end
end
