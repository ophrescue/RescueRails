class ChangeHoursAwayOnAdoptionApp < ActiveRecord::Migration
  def change
    remove_column :adoption_apps, :max_hrs_alone
    add_column :adoption_apps, :max_hrs_alone, :integer
  end

end
