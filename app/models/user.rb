# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :timestamp(6)
#  updated_at             :timestamp(6)
#  encrypted_password     :string(255)
#  salt                   :string(255)
#  admin                  :boolean          default(FALSE)
#  password_reset_token   :string(255)
#  password_reset_sent_at :timestamp(6)
#  is_foster              :boolean          default(FALSE)
#  phone                  :string(255)
#  address1               :string(255)
#  address2               :string(255)
#  city                   :string(255)
#  state                  :string(255)
#  zip                    :string(255)
#  duties                 :string(255)
#  edit_dogs              :boolean          default(FALSE)
#  share_info             :text
#  edit_my_adopters       :boolean          default(FALSE)
#  edit_all_adopters      :boolean          default(FALSE)
#  locked                 :boolean          default(FALSE)
#  edit_events            :boolean          default(FALSE)
#  other_phone            :string(255)
#  lastlogin              :datetime
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password

  strip_attributes :only => :email

  attr_accessible :name, 
                  :email, 
                  :password, 
                  :password_confirmation,
                  :admin,
                  :is_foster,
                  :phone,
                  :other_phone,
                  :address1,
                  :address2,
                  :city,
                  :state,
                  :zip,
                  :duties,
                  :edit_all_adopters,
                  :edit_my_adopters,
                  :edit_dogs,
                  :edit_events,
                  :share_info,
                  :locked
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name,  :presence   => true,
                    :length     => { :maximum => 50 }
  
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
                    
  #Automatically creates the virtual attribute 'password_confirmation'.
  validates :password, :presence      => true,
                       :confirmation  => true,
                       :length        => { :within => 8..40 },
                       :unless => Proc.new { |a| a.password.blank? }
                       
  before_save :encrypt_password, :unless => "password.blank?"

  has_many :histories
  has_many :foster_dogs, :class_name => 'Dog', :foreign_key => 'foster_id'
  has_many :current_foster_dogs, :class_name => 'Dog', :foreign_key => 'foster_id', :conditions => {:status => ['adoptable', 'adoption pending', 'on hold', 'coming soon', 'return pending']}

  has_many :coordinated_dogs, :class_name => 'Dog', :foreign_key => 'coordinator_id', :conditions => {:status => ['adoptable', 'adopted', 'adoption pending', 'on hold', 'coming soon', 'return pending']}

  has_many :comments

  has_many :assignments, :class_name => 'Adopter', :foreign_key => 'assigned_to_user_id'

  has_many :active_applications, :class_name => 'Adopter', :foreign_key => 'assigned_to_user_id', :conditions => {:status => ['new', 'pend response', 'workup', 'approved']}
  
  before_create :chimp_subscribe

  before_update :chimp_check


  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email.downcase.strip)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end  
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def out_of_date?
    if !self.lastverified? || self.lastverified < 30.days.ago
      return true
    else
      return false
    end
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(:validate => false)
    UserMailer.password_reset(self).deliver
  end

  def chimp_subscribe

    gb = Gibbon.new
    gb.timeout = 5

    list_id = '5e50e2be93'

    merge_vars = {
      'FNAME' => self.name,
      'GROUPINGS' => [ { 'name' => 'OPH Target Segments', 'groups' => 'Volunteer'} ]
    }

    double_optin = false

    response = gb.listSubscribe({ :id => list_id,
                                  :email_address => self.email,
                                  :merge_vars => merge_vars,
                                  :double_optin => double_optin,
                                  :send_welcome => false
    })

  end


  def chimp_check

    if self.email_changed?
      self.chimp_subscribe
    end

  end


  private

    def encrypt_password
      self.salt = make_salt unless has_password?(password)
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")  
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

  
end

