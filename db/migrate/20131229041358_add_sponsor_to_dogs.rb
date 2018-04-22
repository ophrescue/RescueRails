class AddSponsorToDogs < ActiveRecord::Migration[4.2]
  def change
    add_column :dogs, :sponsored_by, :string
  end
end
