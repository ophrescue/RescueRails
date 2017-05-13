class AddMedicalReviewToDogs < ActiveRecord::Migration[5.0]
  def change
    add_column :dogs, :medical_review_complete, :boolean, default: false
  end
end
