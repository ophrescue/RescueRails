class AddMedicalNotesToDog < ActiveRecord::Migration
  def change
    add_column  :dogs, :medical_summary, :text
  end
end
