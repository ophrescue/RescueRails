class AddTrainingEmailSentToAdopter < ActiveRecord::Migration[5.0]
  def change
    add_column :adopters, :training_email_sent, :boolean, default: false, null: false
  end
end
