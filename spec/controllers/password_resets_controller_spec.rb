require 'spec_helper'

describe PasswordResetsController, type: :controller do

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

end
