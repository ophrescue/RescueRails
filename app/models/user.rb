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
#  lastverified           :datetime
#  available_to_foster    :boolean          default(FALSE)
#  foster_dog_types       :text
#  complete_adopters      :boolean          default(FALSE)
#  add_dogs               :boolean          default(FALSE)
#  ban_adopters           :boolean          default(FALSE)
#  dl_resources           :boolean          default(TRUE)
#  agreement_id           :integer
#  house_type             :string(40)
#  breed_restriction      :boolean
#  weight_restriction     :boolean
#  has_own_dogs           :boolean
#  has_own_cats           :boolean
#  children_under_five    :boolean
#  has_fenced_yard        :boolean
#  can_foster_puppies     :boolean
#  parvo_house            :boolean
#  admin_comment          :text
#  is_photographer        :boolean
#  writes_newsletter      :boolean
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password,
                :accessible

  strip_attributes :only => :email

  attr_accessible :name,
                  :email,
                  :password,
                  :password_confirmation,
                  :phone,
                  :other_phone,
                  :address1,
                  :address2,
                  :city,
                  :state,
                  :zip,
                  :duties,
                  :share_info,
                  :available_to_foster,
                  :foster_dog_types,
                  :house_type,
                  :breed_restriction,
                  :weight_restriction,
                  :has_own_dogs,
                  :has_own_cats,
                  :children_under_five,
                  :has_fenced_yard,
                  :can_foster_puppies,
                  :parvo_house,
                  :is_transporter

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
  has_one :agreement, as: :attachable, class_name: 'Attachment' ,dependent: :destroy
  has_many :assignments, :class_name => 'Adopter', :foreign_key => 'assigned_to_user_id'
  has_many :active_applications, :class_name => 'Adopter', :foreign_key => 'assigned_to_user_id', :conditions => {:status => ['new', 'pend response', 'workup', 'approved']}

  accepts_nested_attributes_for :agreement

  before_create :chimp_subscribe
  before_update :chimp_check

  scope :active,                  -> { where(locked: false) }
  scope :admin,                   -> { active.where(admin: true) }
  scope :adoption_coordinator,    -> { active.where(edit_my_adopters: true)}
  scope :event_planner,           -> { active.where(edit_events: true)}
  scope :dog_adder,               -> { active.where(add_dogs: true)}
  scope :dog_editor,              -> { active.where(edit_dogs: true)}
  scope :foster,                  -> { active.where(is_foster: true)}
  scope :photographer,            -> { active.where(is_photographer: true)}
  scope :newsletter,              -> { active.where(writes_newsletter: true)}
  scope :transporter,             -> { active.where(is_transporter: true)}

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
    lastverified.blank? || (lastverified.to_date < 30.days.ago.to_date)
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(validate: false)
    UserMailer.password_reset(self).deliver
  end

  def chimp_subscribe
    gb = Gibbon::API.new
    gb.timeout = 30

    list_id = 'aa86c27ddd'

    merge_vars = {
      'FNAME' => name
    }

    gb.lists.subscribe(
      id: list_id,
      email: { email: email },
      merge_vars: merge_vars,
      double_optin: true,
      send_welcome: false
    )
  end

  def chimp_unsubscribe
    gb = Gibbon::API.new
    gb.timeout = 30

    list_id = 'aa86c27ddd'

    gb.lists.unsubscribe({
      id: list_id,
      email: {email: email},
      delete_member: true,
      send_goodbye: false,
      send_notify: false
    })
  end

  def chimp_check
    if email_changed?
      chimp_subscribe
    end

    if locked_changed?
      if locked?
        chimp_unsubscribe
      else
        chimp_subscribe
      end
    end
  end


  private

    def mass_assignment_authorizer(role = :default)
      if accessible == :all
        self.class.protected_attributes
      else
        super + (accessible || [])
      end
    end

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
