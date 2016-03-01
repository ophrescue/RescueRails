# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  encrypted_password     :string(255)
#  salt                   :string(255)
#  admin                  :boolean          default(FALSE)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
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
#  is_photographer        :boolean          default(FALSE)
#  writes_newsletter      :boolean          default(FALSE)
#  is_transporter         :boolean          default(FALSE)
#  mentor_id              :integer
#  latitude               :float
#  longitude              :float
#  dl_locked_resources    :boolean          default(FALSE)
#  training_team          :boolean          default(FALSE)
#

require 'digest'

class User < ActiveRecord::Base
  include Filterable

  attr_accessor :password,
                :accessible

  strip_attributes only: :email

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  presence: true,
                    length: { maximum: 50 }

  validates :email, presence: true,
                    format: { with: email_regex },
                    uniqueness: { case_sensitive: false }

  validates :state, length: { is: 2 }

  validates_format_of :zip,
                    with: /\A\d{5}-\d{4}|\A\d{5}\z/,
                    message: "should be 12345 or 12345-1234",
                    allow_blank: true

  #Automatically creates the virtual attribute 'password_confirmation'.
  validates :password, presence: true,
                       confirmation: true,
                       length: { within: 8..40 },
                       unless: Proc.new { |a| a.password.blank? }

  geocoded_by :full_street_address
  after_validation :geocode

  before_save :encrypt_password, unless: "password.blank?"

  has_many :foster_dogs, class_name: 'Dog', foreign_key: 'foster_id'
  has_many :current_foster_dogs, -> { where(status: ['adoptable', 'adoption pending', 'on hold', 'coming soon', 'return pending']) }, class_name: 'Dog', foreign_key: 'foster_id'
  has_many :coordinated_dogs, -> { where(status: ['adoptable', 'adopted', 'adoption pending', 'on hold', 'coming soon', 'return pending']) }, class_name: 'Dog', foreign_key: 'coordinator_id'
  has_many :comments
  has_one :agreement, as: :attachable, class_name: 'Attachment' ,dependent: :destroy
  has_many :assignments, class_name: 'Adopter', foreign_key: 'assigned_to_user_id'
  has_many :active_applications, -> { where(status: ['new', 'pend response', 'workup', 'approved']) }, class_name: 'Adopter', foreign_key: 'assigned_to_user_id'
  belongs_to :mentor, class_name: 'User', foreign_key: 'mentor_id'
  has_many :mentees, class_name: 'User', foreign_key: 'mentor_id'
  accepts_nested_attributes_for :agreement

  before_save :format_cleanup
  before_create :chimp_subscribe
  before_update :chimp_check

  scope :active,                  -> { where(locked: false) }
  scope :admin,                   -> (status = true) { where(admin: status) }
  scope :adoption_coordinator,    -> (status = true) { where(edit_my_adopters: status) }
  scope :event_planner,           -> (status = true) { where(edit_events: status) }
  scope :dog_adder,               -> (status = true) { where(add_dogs: status) }
  scope :dog_editor,              -> (status = true) { where(edit_dogs: status) }
  scope :foster,                  -> (status = true) { where(is_foster: status) }
  scope :photographer,            -> (status = true) { where(is_photographer: status) }
  scope :newsletter,              -> (status = true) { where(writes_newsletter: status) }
  scope :transporter,             -> (status = true) { where(is_transporter: status) }
  scope :training_team,           -> (status = true) { where(training_team: status)}

  scope :house_type,              -> (type) { where(house_type: type) }
  scope :has_dogs,                -> (status = true) { where(has_own_dogs: status) }
  scope :has_cats,                -> (status = true) { where(has_own_cats: status) }
  scope :has_fence,               -> (status = true) { where(has_fenced_yard: status) }
  scope :has_children_under_five, -> (status = true) { where(children_under_five: status) }
  scope :puppies_ok,              -> (status = true) { where(can_foster_puppies: status) }
  scope :has_parvo_house,         -> (status = true) { where(parvo_house: status) }

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
    UserMailer.password_reset(self).deliver_later
  end

  def chimp_subscribe
    MailChimpService.user_subscribe(name, email)
  end

  def chimp_unsubscribe
    MailChimpService.user_unsubscribe(email)
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

    def full_street_address
      [address1, address2, city, state, zip].compact.join(', ')
    end

    def format_cleanup
      self.state.upcase!
      self.email.downcase!
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
