class CreateTreatmentRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :treatment_records do |t|
      t.belongs_to :treatment, foreign_key: true
      t.integer :treatable_id
      t.string :treatable_type
      t.integer :treatment_id
      t.date :administered_date
      t.string :results
      t.text :comments
      t.timestamps
    end
  end
end
