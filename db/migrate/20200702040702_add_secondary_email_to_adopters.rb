class AddSecondaryEmailToAdopters < ActiveRecord::Migration[5.2]
  def change
    add_column :adopters, :secondary_email, :string
  end
end
