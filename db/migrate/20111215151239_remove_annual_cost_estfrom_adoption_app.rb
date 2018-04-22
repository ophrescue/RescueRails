class RemoveAnnualCostEstfromAdoptionApp < ActiveRecord::Migration[4.2]
  def change
    remove_column :adoption_apps, :annual_cost_est
  end
end
