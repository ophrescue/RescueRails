class RemoveAnnualCostEstfromAdoptionApp < ActiveRecord::Migration
  def change
    remove_column :adoption_apps, :annual_cost_est
  end
end
