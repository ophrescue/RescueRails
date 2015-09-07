require 'rails_helper'

describe PasswordResetsController, type: :controller do

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      expect(response).to be_success
    end
  end

end
