# == Schema Information
#
# Table name: adopters
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  email               :string(255)
#  phone               :string(255)
#  address1            :string(255)
#  address2            :string(255)
#  city                :string(255)
#  state               :string(255)
#  zip                 :string(255)
#  status              :string(255)
#  when_to_call        :string(255)
#  created_at          :timestamp(6)
#  updated_at          :timestamp(6)
#  dog_reqs            :text
#  why_adopt           :text
#  dog_name            :string(255)
#  other_phone         :string(255)
#  assigned_to_user_id :integer
#  flag                :string(255)
#  is_subscribed       :boolean          default(FALSE)
#  completed_date      :date
#

require 'spec_helper'

describe Adopter do
	before(:each) do
		@attr = { :name  => "Fake Adopter",
				  :email => "fake@fake.com",
				  :phone => "717-814-8284",
				  :address1 => "500 Eastern Ave.",
				  :address2 => "Apartment 3C",
				  :city => "Baltimore",
				  :state => "MD",
				  :zip => "21224",
				  :when_to_call => "anytime",
          :status => "pending"
        }
          # :spouse_name => "Miss Spouse",             
          # :other_household_names => "OtherHouse People" ,    
          # :ready_to_adopt_dt      =>  "2011-01-01" , 
          # :house_type            => 'Rent',
          # :dog_reqs                 => 'Be Awesome',
          # :has_yard              => 1,
          # :has_fence                => 1 ,
          # :has_parks                =>  1 ,
          # :dog_exercise              => "Dog will goto Gym" ,
          # :dog_stay_when_away       =>  "In crate",
          # :max_hrs_alone            =>  8,
          # :dog_at_night             =>  "In crate",
          # :dog_vacation              =>  "dog vacation",
          # :have_pets                 =>  1,
          # :had_pets                  =>  1,
          # :current_pets          =>  "My current pets",
          # :current_pets_fixed    => 1,
          # :why_not_fixed          => "they are fixed",
          # :prior_pets              =>  "List of old dogs",
          # :current_pets_uptodate      => 1,
          # :current_pets_uptodate_why  => "upto date",
          # :vet_name                   => "Dr Pets",
          # :vet_phone                => "800-222-2222",
          # :landlord_name           =>  "Mr Landlord",
          # :landlord_phone           =>  "111-111-1111",
          # :rent_dog_restrictions     =>  "No Dog Restrictions",
          # :rent_deposit          =>  100,
          # :rent_increase         =>  200,
          # :annual_cost_est          =>  500 ,
          # :plan_training              => "I will train",
          # :has_new_dog_exp       =>  1,
          # :surrender_pet_causes  =>  "if it barks",
          # :training_explain     =>    "I will train",
          # :surrendered_pets   =>   "I never gave up a pet before",
          # :why_adopt        =>  "I want a dog"    
          # }                 
	end

	it "should createa a new instance given valid attributes" do
		Adopter.create!(@attr)
	end

  	it "should require a name" do
    	no_name_user = Adopter.new(@attr.merge(:name => ""))
    	no_name_user.should_not be_valid
  	end
  
  	it "should require an email address" do
    	no_email_user = Adopter.new(@attr.merge(:email => "" ))
    	no_email_user.should_not be_valid
  	end
  
  	it "should reject names that are too long" do
    	long_name = "a" * 51
    	long_name_user = Adopter.new(@attr.merge(:name => long_name))
    	long_name_user.should_not be_valid
  	end
  
  	it "should accept valid email address" do
    	addresses = %w[user@foo.com THE_USER@derp.mail.org first.last@beer.jp]
    	addresses.each do |address|
      		valid_email_user = Adopter.new(@attr.merge(:email => address))
      		valid_email_user.should be_valid
    	end
  	end
  
  	it "should reject invalid email address" do
    	addresses = %w[user@foocom THE_USER_AT_derp.mail.org first.last@beer.]
        addresses.each do |address|
        	valid_email_user = Adopter.new(@attr.merge(:email => address))
        	valid_email_user.should_not be_valid
      	end
    end
  
  	it "should reject duplicate email addresses" do
    	Adopter.create!(@attr)
    	user_with_duplicate_email = Adopter.new(@attr)
    	user_with_duplicate_email.should_not be_valid
  	end
  
  	it "should reject email addresses identical up to case" do
    	upcased_email = @attr[:email].upcase
    	Adopter.create!(@attr.merge(:email => upcased_email))
    	user_with_duplicate_email = Adopter.new(@attr)
    	user_with_duplicate_email.should_not be_valid
  	end

end






