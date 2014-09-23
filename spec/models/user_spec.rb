# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :timestamp(6)
#  updated_at             :timestamp(6)
#  encrypted_password     :string(255)
#  salt                   :string(255)
#  admin                  :boolean          default(FALSE)
#  password_reset_token   :string(255)
#  password_reset_sent_at :timestamp(6)
#  is_foster              :boolean          default(FALSE)
#  phone                  :string(255)
#  address1               :string(255)
#  address2               :string(255)
#  city                   :string(255)
#  state                  :string(255)
#  zip                    :string(255)
#  duties                 :string(255)
#  edit_dogs              :boolean          default(FALSE)
#  share_info             :text
#  edit_my_adopters       :boolean          default(FALSE)
#  edit_all_adopters      :boolean          default(FALSE)
#  locked                 :boolean          default(FALSE)
#  edit_events            :boolean          default(FALSE)
#  other_phone            :string(255)
#  lastlogin              :datetime
#  lastverified           :datetime
#  available_to_foster    :boolean          default(FALSE)
#  foster_dog_types       :text
#  complete_adopters      :boolean          default(FALSE)
#  add_dogs               :boolean          default(FALSE)
#  ban_adopters           :boolean          default(FALSE)
#  dl_resources           :boolean          default(TRUE)
#  agreement_id           :integer
#  house_type             :string(40)
#  breed_restriction      :boolean
#  weight_restriction     :boolean
#  has_own_dogs           :boolean
#  has_own_cats           :boolean
#  children_under_five    :boolean
#  has_fenced_yard        :boolean
#  can_foster_puppies     :boolean
#  parvo_house            :boolean
#  admin_comment          :text
#  is_photographer        :boolean
#  writes_newsletter      :boolean
#

# require 'spec_helper'

# describe User do
#   before(:each) do
#     @attr = { :name => "Basic User",
#               :email => "user@example.com",
#               :password => "foobar",
#               :password_confirmation => "foobar" 
#     }
#   end
  
#   it "should not allow non signed in users to create a user"


#   it "should not allow non-admins to create a user"

#   it "should allow only admins to create a user" do
#       User.create!(@attr)
#   end
  
#   it "should require a name" do
#     no_name_user = User.new(@attr.merge(:name => ""))
#     no_name_user.should_not be_valid
#   end
  
#   it "should require an email address" do
#     no_email_user = User.new(@attr.merge(:email => "" ))
#     no_email_user.should_not be_valid
#   end
  
#   it "should reject names that are too long" do
#     long_name = "a" * 51
#     long_name_user = User.new(@attr.merge(:name => long_name))
#     long_name_user.should_not be_valid
#   end
  
#   it "should accept valid email address" do
#     addresses = %w[user@foo.com THE_USER@derp.mail.org first.last@beer.jp]
#     addresses.each do |address|
#       valid_email_user = User.new(@attr.merge(:email => address))
#       valid_email_user.should be_valid
#     end
#   end
  
#   it "should reject invalid email address" do
#       addresses = %w[user@foocom THE_USER_AT_derp.mail.org first.last@beer.]
#       addresses.each do |address|
#         valid_email_user = User.new(@attr.merge(:email => address))
#         valid_email_user.should_not be_valid
#       end
#     end
  
#   it "should reject duplicate email addresses" do
#     User.create!(@attr)
#     user_with_duplicate_email = User.new(@attr)
#     user_with_duplicate_email.should_not be_valid
#   end
  
#   it "should reject email addresses identical up to case" do
#     upcased_email = @attr[:email].upcase
#     User.create!(@attr.merge(:email => upcased_email))
#     user_with_duplicate_email = User.new(@attr)
#     user_with_duplicate_email.should_not be_valid
#   end
  
#   ## Password Validations
#   describe "password validations" do
    
#     it "should require a password" do
#       no_pass_user = User.new(@attr.merge(:password => "", :password_confirmation => ""))
#       no_pass_user.should_not be_valid
#     end
    
#     it "should require a matching password confirmation" do
#       no_passmatch_user = User.new(@attr.merge(:password => "invalid"))
#       no_passmatch_user.should_not be_valid
#     end
    
#     it "should reject short passwords" do
#       shortpass = "a" * 5
#       shortpass_user = User.new(@attr.merge(:password => shortpass))
#       shortpass_user = User.new(@attr.merge(:password_confirmation => shortpass))
#       shortpass_user.should_not be_valid
#     end
    
#     it "should reject long passwords" do
#       longpass = "a" * 41
#       longpass_user = User.new(@attr.merge(:password => longpass))
#       longpass_user = User.new(@attr.merge(:password_confirmation => longpass))
#       longpass_user.should_not be_valid
#     end
    
#   end

  
#   describe "password encryption" do
#     before(:each) do
#       @user = User.create!(@attr)
#     end
    
#     it "should have an encrypted password attribute" do
#       @user.should respond_to(:encrypted_password)
#     end
    
#     it "should set the encrypted password" do
#       @user.encrypted_password.should_not be_blank
#     end
#   end
  
#   describe "has_password? method" do
    
#     before(:each) do
#       @user = User.create!(@attr)
#     end
    
#     it "should be true if the passwords match" do
#       @user.has_password?(@attr[:password]).should be_true
#     end
    
#     it "should be false if the passwords don't match" do
#       @user.has_password?("invalid").should be_false
#     end
#   end
  
#   describe "authenticate method" do
    
#     before(:each) do
#       @user = User.create!(@attr)
#     end
    
#     it "should return nil on email/password mismatch" do
#       wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
#       wrong_password_user.should be_nil
#     end
    
#     it "should return nil for an email address with no user" do
#       nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
#       nonexistent_user.should be_nil
#     end
    
#     it "should return the user on email/password match" do
#       matching_user = User.authenticate(@attr[:email], @attr[:password])
#       matching_user.should == @user
#     end
#   end

#   describe "admin attribute" do

#     before(:each) do
#       @user = User.create!(@attr)
#     end

#     it "should respond to admin" do
#       @user.should respond_to(:admin)
#     end

#     it "should not be an admin by default" do
#       @user.should_not be_admin
#     end

#     it "should be convertible to an admin" do
#       @user.toggle!(:admin)
#       @user.should be_admin
#     end
#   end
# end

