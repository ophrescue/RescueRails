class Adopter < ActiveRecord::Base

    validates :name,  :presence   => true,
                      :length     => { :maximum => 50 }

    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
    validates :email, :presence   => true,
                      :format     => { :with => email_regex },
                      :uniqueness => { :case_sensitive => false }

    validates :phone, :presence	  => true,
    				  :length     => {:in => 10..25 }

    validates :address1, :presence => true

    validates :city,	 :presence => true

    validates :state,    :presence => true,
    					 :length   => { :is => 2 }
    					
    validates :zip,		 :presence => true,
    					 :length   => {:in => 5..10}
             
	STATUSES = ['approved', 'pending', 'denied', 
		        'unresponsive', 'on hold', 'withdrawn']
	
	validates_presence_of  :status
	validates_inclusion_of :status, :in => STATUSES

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

