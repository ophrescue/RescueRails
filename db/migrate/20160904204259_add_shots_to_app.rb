class AddShotsToApp < ActiveRecord::Migration
  def change
    change_column :adoption_apps, :current_pets_uptodate, :boolean, default: nil

    add_column :adoption_apps, :shot_dhpp_dhlpp, :boolean, default: nil
    add_column :adoption_apps, :shot_fpv_fhv_fcv, :boolean, default: nil
    add_column :adoption_apps, :shot_rabies, :boolean, default: nil
    add_column :adoption_apps, :shot_bordetella, :boolean, default: nil
    add_column :adoption_apps, :shot_heartworm, :boolean, default: nil
    add_column :adoption_apps, :shot_flea_tick, :boolean, default: nil
  end
end
