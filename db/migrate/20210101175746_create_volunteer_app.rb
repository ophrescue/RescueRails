class CreateVolunteerApp < ActiveRecord::Migration[5.2]
  def change
    create_table :volunteer_apps do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :address1
      t.string :address2
      t.string :city
      t.string :region, limit: 2, comment: "Region (state or province) as a 2 character ISO 3166-2 code"
      t.string :postal_code, comment: "Postal code - ZIP code for US addresses"
      t.string :referrer
      t.boolean :writing_interest
      t.boolean :events_interest
      t.boolean :fostering_interest
      t.boolean :training_interest
      t.boolean :fundraising_interest
      t.boolean :transport_bb_interest
      t.boolean :adoption_team_interest
      t.boolean :admin_interest
      t.text   :about
    end
  end
end
