class AddMedicalNotesToDog < ActiveRecord::Migration
  def change
    add_column  :dogs, :medical_notes, :text
  end
end
