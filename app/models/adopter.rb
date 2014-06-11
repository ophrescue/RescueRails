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
#  is_subscribed       :boolean          default(FALSE)
#  completed_date      :date
#

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
#  is_subscribed       :boolean          default(FALSE)
#  completed_date      :date
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
              'adptd sn pend',
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

      gb = Gibbon::API.new
      gb.timeout = 30

      list_id = '5e50e2be93'

      if (self.status == 'adopted') || (self.status == 'completed')
        groups = [ { :name => "OPH Target Segments", :groups => ["Adopted from OPH"]} ]
      else
        groups = [ { :name => "OPH Target Segments", :groups => ["Active Application"]} ]
      end


      if (self.status == 'completed')
        completed_date = Time.now.strftime("%m/%d/%Y")
      else
        completed_date = ''
      end

      merge_vars = {
        :fname => self.name,
        :mmerge2 => self.status,
        :mmerge3 => completed_date,
        :groupings => groups
      }

      double_optin = true


      if self.is_subscribed?
          response = gb.lists.update_member({ :id => list_id,
                             :email => {:email => self.email},
                             :merge_vars => merge_vars,
                             :double_optin => double_optin,
                             :send_welcome => false
          })
      else
          response = gb.lists.subscribe({ :id => list_id,
                                        :email => {:email => self.email},
                                        :merge_vars => merge_vars,
                                        :double_optin => double_optin,
                                        :send_welcome => false
          })

          self.is_subscribed = true
      end
    end


    def chimp_check

      if self.status_changed?

        if ((self.status == 'withdrawn') || (self.status == 'denied')) && (self.is_subscribed?)
          self.chimp_unsubscribe
        else
          self.chimp_subscribe
        end

      end

    end
    
    def chimp_unsubscribe

      gb = Gibbon::API.new
      gb.timeout = 30
      gb.throws_exceptions = false;

      list_id = '5e50e2be93'

      response = gb.lists.unsubscribe({
        :id => list_id,
        :email => {:email => self.email},
        :delete_member => true,
        :send_goodbye => false,
        :send_notify => false
        })

      self.is_subscribed = 0   

    end

end

