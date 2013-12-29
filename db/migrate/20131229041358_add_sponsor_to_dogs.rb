class AddSponsorToDogs < ActiveRecord::Migration
  def change
    add_column :dogs, :sponsored_by, :string
  end
end
