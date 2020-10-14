class AddInsuranceTrainingIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :insurance_training_agreement_id, :integer
  end
end
