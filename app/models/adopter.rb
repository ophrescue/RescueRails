class Adopter < ActiveRecord::Base

  attr_accessor :pre_q_age,
                :pre_q_costs,
                :pre_q_surrender,
                :pre_q_abuse,
                :pre_q_reimbursement 
                  

  attr_reader :dog_tokens

  def dog_tokens=(ids)
    self.dog_ids = ids.split(",")
  end

#Prescreen Questions
    validates_acceptance_of :pre_q_age, 
                            :message => "If you are under 21, have a parent complete this application."
    validates_acceptance_of :pre_q_commited, 
                            :message => "All family members must be commited to adopt from OPH"
    validates_acceptance_of :pre_q_costs,
                            :message => "Review the costs."
    validates_acceptance_of :pre_q_meds,
                            :message => "These medications are required by contract."
    validates_acceptance_of :pre_q_surrender,
                            :message => "All OPH dogs are required to be returned to OPH if given up."
    validates_acceptance_of :pre_q_abuse,
                            :message => "We are unable to adopt to individuals convicted of animal abuse."

    has_many :references, :dependent => :destroy
    accepts_nested_attributes_for :references

    has_many :adoptions, :dependent => :destroy
    has_many :dogs, :through => :adoptions

    has_one :adoption_app, :dependent => :destroy
    accepts_nested_attributes_for :adoption_app

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
#  id           :integer         not null, primary key
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
#  dog_reqs     :text
#  why_adopt    :text
#  dog_name     :string(255)
#  other_phone  :string(255)
#

