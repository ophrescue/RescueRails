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
				  :status => "pending",
				  :when_to_call => "anytime"}
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

# == Schema Information
#
# Table name: adopters
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  email        :string(255)
#  phone        :string(255)
#  address1     :string(255)
#  address2     :string(255)
#  city         :string(255)
#  state        :string(255)
#  zip          :string(255)
#  status       :string(255)
#  when_to_call :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

