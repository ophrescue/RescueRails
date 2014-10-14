require 'spec_helper'

describe AdoptersController do
  render_views

  describe "GET 'new'" do

  it "should be successful" do
      get :new
      response.should be_success
    end

  describe "POST 'create'" do

    describe "success" do

      before(:each) do
        @attr = { :name         => "New User", 
              :email      => "user@example.com",
              :phone      => "111-222-4444",
              :address1     => "100 Fake Street",
              :address2     => "",
              :city       => "Baltimore",
              :state      => "MD",
              :zip        => "21224",
              :status     => "pending",
              :when_to_call   => "After 6pm"}

        @adoptapp_attr = {
              :spouse_name           => "Spouse",         
              :other_household_names     => "other household",
              :ready_to_adopt_dt     =>    "2020-01-01",
              :house_type           =>     "rent",
              :dog_reqs           =>      "Must be cute and under 40lbs",
              :has_yard           => true,
              :has_fence          => false,       
              :has_parks           => true,   
              :dog_exercise        => "will go to the gym",      
              :dog_stay_when_away      => "In a crate",  
              :max_hrs_alone            => 3 ,
              :dog_at_night              => 'In a crate',
              :dog_vacation              => 'dog vacation',
              :have_pets                 => true,
              :had_pets                  => true,
              :current_pets              => "currently have a bunch of dogs",
              :current_pets_fixed        => true,
              :why_not_fixed             => '',
              :prior_pets                => "none",
              :current_pets_uptodate     => true,
              :current_pets_uptodate_why => "none",
              :vet_name                  => "Dr Kreiger",
              :vet_phone                 => "1-800-DOG-MD4U",
              :landlord_name             => "Mr. Landlord",
              :landlord_phone           => "443-111-1090",
              :rent_dog_restrictions     => "no pittbulls",
              :rent_deposit              => "500",
              :rent_increase             => "200",
              :plan_training          => "go to dog school",   
              :has_new_dog_exp           => true,
              :surrender_pet_causes    => "if it bit me",  
              :training_explain       => "i like training",   
              :surrendered_pets      => "never",    
              :why_adopt              => "dogs are cute and stuff"   
              }
        end
    
      it "should create a user" do 
        lambda do
         post :create, :adopter => @attr
        end.should change(Adopter, :count).by(1)
      end
    end
    end
  end
end
