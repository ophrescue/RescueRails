class CreateVolunteerReferences < ActiveRecord::Migration[6.0]
  def change
    create_table :volunteer_references do |t|
      t.belongs_to :volunteer_app, index: true, foreign_key: true
      t.string :name
      t.string :email
      t.string :phone
      t.string :relationship
      t.timestamps
    end
  end
end
