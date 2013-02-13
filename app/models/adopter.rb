# == Schema Information
#
# Table name: adopters
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  email               :string(255)
#  phone               :string(255)
#  address1            :string(255)
#  address2            :string(255)
#  city                :string(255)
#  state               :string(255)
#  zip                 :string(255)
#  status              :string(255)
#  when_to_call        :string(255)
#  created_at          :timestamp(6)
#  updated_at          :timestamp(6)
#  dog_reqs            :text
#  why_adopt           :text
#  dog_name            :string(255)
#  other_phone         :string(255)
#  assigned_to_user_id :integer
#  flag                :string(255)
#  is_subscribed       :boolean          default(TRUE)
#

class Adopter < ActiveRecord::Base

  attr_accessor :pre_q_costs,
    :pre_q_surrender,
    :pre_q_abuse,
    :pre_q_reimbursement,
    :pre_q_limited_info,
    :pre_q_breed_info

  attr_reader :dog_tokens

  attr_accessible :name,
                  :email,
                  :phone,
                  :address1,
                  :address2,
                  :city,
                  :state,
                  :zip,                
                  :status,   
                  :when_to_call,
                  :dog_reqs,       
                  :why_adopt,   
                  :dog_name,
                  :other_phone,
                  :assigned_to_user_id,
                  :flag,
                  :pre_q_costs, 
                  :pre_q_surrender, 
                  :pre_q_abuse, 
                  :pre_q_reimbursement, 
                  :adoption_app_attributes, 
                  :references_attributes,
                  :pre_q_limited_info,
                  :pre_q_breed_info

  def dog_tokens=(ids)
    self.dog_ids = ids.split(",")
  end

  has_many :references, :dependent => :destroy
  accepts_nested_attributes_for :references

  has_many :adoptions, :dependent => :destroy
  accepts_nested_attributes_for :adoptions

  has_many :dogs, :through => :adoptions

  has_one :adoption_app, :dependent => :destroy
  accepts_nested_attributes_for :adoption_app

  has_many :comments, :as => :commentable, :order => "created_at DESC"

  belongs_to :user, :class_name => 'User', :primary_key => 'id', :foreign_key => 'assigned_to_user_id'


  validates :name,  :presence   => true,
    :length     => { :maximum => 50 }

  validates :phone, :presence	  => true,
    :length     => {:in => 10..25 }

  validates :address1, :presence => true

  validates :city, :presence => true

  validates :state,    :presence => true,
    :length   => { :is => 2 }

  validates :zip, :presence => true,
    :length   => {:in => 5..10}

  STATUSES = ['new',
              'pend response',
              'workup',
              'approved',
              'adopted',
              'completed',
              'standby',
              'withdrawn',
              'denied']

  FLAGS = ['High','Low','On Hold']


  validates_presence_of  :status
  validates_inclusion_of :status, :in => STATUSES

  before_create :chimp_subscribe

  before_update :chimp_check

    def chimp_subscribe

      gb = Gibbon.new
      gb.timeout = 5

      list_id = '5e50e2be93'

#Dupe Code Refactor at some point

      if (self.status == 'adopted')
        groups = [ { 'name' => 'OPH Target Segments', 'groups' => 'Adopted from OPH'} ]
        adopt_date = Time.now.strftime("%m/%d/%Y")
      else
        groups = [ { 'name' => 'OPH Target Segments', 'groups' => 'Active Application'} ]
        adopt_date = ''
      end

      merge_vars = {
        'FNAME' => self.name,
        'MMERGE2' => self.status,
        'MMERGE3' => adopt_date,
        'GROUPINGS' => [ { 'name' => 'OPH Target Segments', 'groups' => 'Active Application'} ]
      }

      double_optin = false

      response = gb.listSubscribe({ :id => list_id,
                                    :email_address => self.email,
                                    :merge_vars => merge_vars,
                                    :double_optin => double_optin,
                                    :send_welcome => false
      })

      self.is_subscribed = true

    end


    def chimp_check


      if self.status_changed?

        if ((self.status == 'withdrawn') || (self.status == 'denied')) && (self.is_subscribed == true)
          self.chimp_unsubscribe
        elsif self.is_subscribed?
          self.chimp_update
        elsif self.is_subscribed == false
          self.chimp_subscribe
        end

      end

    end
    

    def chimp_update

      gb = Gibbon.new
      gb.timeout = 5

      list_id = '5e50e2be93'

#Dupe Code Refactor at some point

      if (self.status == 'adopted') || (self.status == 'completed')
        groups = [ { 'name' => 'OPH Target Segments', 'groups' => 'Adopted from OPH'} ]
        adopt_date = Time.now.strftime("%m/%d/%Y")
      else
        groups = [ { 'name' => 'OPH Target Segments', 'groups' => 'Active Application'} ]
        adopt_date = ''
      end

      merge_vars = {
        'FNAME' => self.name,
        'MMERGE2' => self.status,
        'MMERGE3' => adopt_date,
        'GROUPINGS' => groups
      }

      double_optin = false

      response = gb.listUpdateMember({ :id => list_id,
                                       :email_address => self.email,
                                       :merge_vars => merge_vars,
                                       :double_optin => double_optin,
                                       :send_welcome => false
      })
    end


    def chimp_unsubscribe

      gb = Gibbon.new
      gb.timeout = 5

      list_id = '5e50e2be93'

      response = gb.listUnsubscribe({
        :id => list_id,
        :email_address => self.email,
        :delete_member => true,
        :send_goodbye => false,
        :send_notify => false
        })

      self.is_subscribed = 0   

    end

end

