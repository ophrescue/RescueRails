require 'spec_helper'

describe SessionsController, type: :controller do

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      expect(response).to be_success
    end

  end

  describe "POST 'create'" do

    describe "invalid signin" do

      before(:each) do
        @attr = { :email => "email@example.com", :password => "invalid" }
      end

      it "should re-render the new page" do
        post :create, :session => @attr
        expect(response).to render_template('new')
      end

      it "should have a flash.now message" 
    end

    describe "with valid email and password" do

      it "should sign the user in" 
    end


  end

  describe "DELETE 'destory'" do
    it "should sign a user out"
  end
  
end
