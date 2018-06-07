class DropAdoptapetAdUrlFromDogs < ActiveRecord::Migration[5.2]
  def change
    remove_column :dogs, :adoptapet_ad_url, :string
  end
end
