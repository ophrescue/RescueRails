class AddMedicalNotesToDog < ActiveRecord::Migration[4.2]
  def change
    add_column  :dogs, :medical_summary, :text
  end
end
