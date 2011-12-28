class Adopter < ActiveRecord::Base

  attr_accessor :pre_q_costs,
                :pre_q_surrender,
                :pre_q_abuse,
                :pre_q_reimbursement 
                  

  attr_reader :dog_tokens

  def dog_tokens=(ids)
    self.dog_ids = ids.split(",")
  end

    has_many :references, :dependent => :destroy
    accepts_nested_attributes_for :references

    has_many :adoptions, :dependent => :destroy
    has_many :dogs, :through => :adoptions

    has_one :adoption_app, :dependent => :destroy
    accepts_nested_attributes_for :adoption_app

    has_many :comments, :as => :commentable
    accepts_nested_attributes_for :comments

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
             
	STATUSES = ['new', 
              'pend response', 
              'workup', 
		          'approved',
              'adopted',
              'withdrawn',
              'denied']

	
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

