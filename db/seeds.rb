# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create default admin user.

User.destroy_all

@attr = { name: "Admin User",
          email: "test@test.com",
          password: "foobar99",
          password_confirmation: "foobar99",
}

 user = User.create!(@attr)
 user.toggle!(:admin)


 # Load list of breeds to breed table

 Breed.destroy_all
 open("db/dog_breeds.txt") do |breeds|
 	breeds.read.each_line do |breed|
 		breed = breed.chomp
 		Breed.create!(name: breed)
 	end
 end

Adopter.destroy_all

params = { adopter: 						{
							name: "John Smith", 
							email: "jsmith@temp.blg", 
							phone: "(555) 555-5555", 
							address1: "5555 Eastern Ave", 
							address2: "", 
							city: "Baltimore", 
							state: "MD", 
							zip: "21224", 
							status: "new", 
							when_to_call: "any", 
							dog_reqs: "Low shedding, medium sized", 
							why_adopt: "I am resubmitting my application, I believe I've be...", 
							dog_name: "Sir Robyn Hood", 
							other_phone: "", 
							assigned_to_user_id: nil, 
							flag: "", 
							is_subscribed: true,
							adoption_app_attributes: {
								spouse_name: "Jill Smith", 
								other_household_names: "", 
								ready_to_adopt_dt: "2012-01-28", 
								house_type: "own", 
								dog_exercise: "We are moving into our new house on 1/21/12, and it...", 
								dog_stay_when_away: "In a limited area of home", 
								dog_vacation: "We will have friends stay at the house while we are...", 
								current_pets: nil, 
								why_not_fixed: nil, 
								current_pets_uptodate: nil, 
								current_pets_uptodate_why: nil, 
								landlord_name: nil, 
								landlord_phone: nil, 
								rent_dog_restrictions: nil, 
								surrender_pet_causes: "If the dog became overly aggressive and professiona...", 
								training_explain: "If we feel that we and the dog will benefit from tr...", 
								surrendered_pets: "no",  
								how_did_you_hear: "my mother went to an event at Bark!", 
								pets_branch: "no_pets", 
								current_pets_fixed: nil, 
								rent_costs: nil, 
								vet_info: nil, 
								max_hrs_alone: 9, 
								is_ofage: true
							}
						}
}

Adopter.create!(params[:adopter])
