class AddFlagsToDogs < ActiveRecord::Migration
  def change
  	add_column :dogs, :has_medical_need, :boolean, default: false
  	add_column :dogs, :is_high_priority, :boolean, default: false
  	add_column :dogs, :needs_photos, :boolean, default: false
  	add_column :dogs, :has_behavior_problem, :boolean, default: false
  	add_column :dogs, :needs_foster, :boolean, default: false
  end
end
