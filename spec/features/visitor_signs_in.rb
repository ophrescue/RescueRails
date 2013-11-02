require 'spec_helper'

describe "the sigin process" do 
	# before :each do
	# 	User.make(:email => 'user@example.com', :password => 'foobar')		
	# end	

	it "signs me in" do
		visit '/signin'
		expect(page).to have_content 'Staff Sign in'
	end
end