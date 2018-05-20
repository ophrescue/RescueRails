#    Copyright 2017 Operation Paws for Homes
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
# == Schema Information
#
# Table name: users
#
#  id                           :integer          not null, primary key
#  name                         :string(255)
#  email                        :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  encrypted_password           :string(255)
#  salt                         :string(255)
#  admin                        :boolean          default(FALSE)
#  password_reset_token         :string(255)
#  password_reset_sent_at       :datetime
#  is_foster                    :boolean          default(FALSE)
#  phone                        :string(255)
#  address1                     :string(255)
#  address2                     :string(255)
#  city                         :string(255)
#  region                       :string(2)
#  postal_code                  :string(255)
#  duties                       :string(255)
#  edit_dogs                    :boolean          default(FALSE)
#  share_info                   :text
#  edit_my_adopters             :boolean          default(FALSE)
#  edit_all_adopters            :boolean          default(FALSE)
#  locked                       :boolean          default(FALSE)
#  edit_events                  :boolean          default(FALSE)
#  other_phone                  :string(255)
#  lastlogin                    :datetime
#  lastverified                 :datetime
#  available_to_foster          :boolean          default(FALSE)
#  foster_dog_types             :text
#  complete_adopters            :boolean          default(FALSE)
#  add_dogs                     :boolean          default(FALSE)
#  ban_adopters                 :boolean          default(FALSE)
#  dl_resources                 :boolean          default(TRUE)
#  agreement_id                 :integer
#  house_type                   :string(40)
#  breed_restriction            :boolean
#  weight_restriction           :boolean
#  has_own_dogs                 :boolean
#  has_own_cats                 :boolean
#  children_under_five          :boolean
#  has_fenced_yard              :boolean
#  can_foster_puppies           :boolean
#  parvo_house                  :boolean
#  admin_comment                :text
#  is_photographer              :boolean          default(FALSE)
#  writes_newsletter            :boolean          default(FALSE)
#  is_transporter               :boolean          default(FALSE)
#  mentor_id                    :integer
#  latitude                     :float
#  longitude                    :float
#  dl_locked_resources          :boolean          default(FALSE)
#  training_team                :boolean          default(FALSE)
#  confidentiality_agreement_id :integer
#  foster_mentor                :boolean          default(FALSE)
#  public_relations             :boolean          default(FALSE)
#  fundraising                  :boolean          default(FALSE)
#  translator                   :boolean          default(FALSE), not null
#  known_languages              :string(255)
#  code_of_conduct_agreement_id :integer
#  boarding_buddies             :boolean          default(FALSE), not null
#  medical_behavior_permission  :boolean          default(FALSE)
#  social_media_manager         :boolean          default(FALSE), not null
#  graphic_design               :boolean          default(FALSE), not null
#  country                      :string(3)        not null
#  active                       :boolean          default(FALSE), not null

require 'digest'

class User < ApplicationRecord
  include Clearance::User

  include Filterable

  attr_accessor :accessible

  strip_attributes only: :email

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  presence: true,
                    length: { maximum: 50 }

  validates :email, presence: true,
                    format: { with: email_regex },
                    uniqueness: { case_sensitive: false }

  # Automatically creates the virtual attribute 'password_confirmation'.
  validates :password, presence: true,
                       confirmation: true,
                       length: { within: 8..40 },
                       if: Proc.new { |a| a.password.present? }

  validates :country, length: { is: 3 }
  validate :country_is_supported

  validates_with RegionValidator
  validates_with PostalCodeValidator

  geocoded_by :full_street_address
  after_validation :geocode

  has_many :foster_dogs, class_name: 'Dog', foreign_key: 'foster_id', inverse_of: :foster
  has_many :current_foster_dogs, -> { where(status: ['adoptable', 'adoption pending', 'on hold', 'coming soon', 'return pending']) }, class_name: 'Dog', foreign_key: 'foster_id'
  has_many :coordinated_dogs, -> { where(status: ['adoptable', 'adopted', 'adoption pending', 'on hold', 'coming soon', 'return pending']) }, class_name: 'Dog', foreign_key: 'coordinator_id'
  has_many :comments

  has_one :agreement, -> { where(agreement_type: Attachment::AGREEMENT_TYPE_FOSTER) },
          as: :attachable, class_name: 'Attachment', dependent: :destroy
  accepts_nested_attributes_for :agreement

  has_one :confidentiality_agreement, -> { where(agreement_type: Attachment::AGREEMENT_TYPE_CONFIDENTIALITY) },
          as: :attachable, class_name: 'Attachment', dependent: :destroy
  accepts_nested_attributes_for :confidentiality_agreement

  has_one :code_of_conduct_agreement, -> { where(agreement_type: Attachment::AGREEMENT_TYPE_CODE_OF_CONDUCT) },
          as: :attachable, class_name: 'Attachment', dependent: :destroy
  accepts_nested_attributes_for :code_of_conduct_agreement

  has_many :assignments, class_name: 'Adopter', foreign_key: 'assigned_to_user_id'
  has_many :active_applications, -> { where(status: ['new', 'pend response', 'workup', 'ready for final', 'approved']) }, class_name: 'Adopter', foreign_key: 'assigned_to_user_id'
  belongs_to :mentor, class_name: 'User', foreign_key: 'mentor_id'
  has_many :mentees, class_name: 'User', foreign_key: 'mentor_id'

  before_validation :sanitize_postal_code
  before_validation :sanitize_region

  before_save :format_cleanup
  before_create :chimp_subscribe
  before_update :chimp_check

  scope :unlocked,                -> { where(locked: false) }
  scope :admin,                   -> (status = true) { where(admin: status) }
  scope :adoption_coordinator,    -> (status = true) { where(edit_my_adopters: status) }
  scope :event_planner,           -> (status = true) { where(edit_events: status) }
  scope :dog_adder,               -> (status = true) { where(add_dogs: status) }
  scope :dog_editor,              -> (status = true) { where(edit_dogs: status) }
  scope :foster,                  -> (status = true) { where(is_foster: status) }
  scope :photographer,            -> (status = true) { where(is_photographer: status) }
  scope :newsletter,              -> (status = true) { where(writes_newsletter: status) }
  scope :transporter,             -> (status = true) { where(is_transporter: status) }
  scope :training_team,           -> (status = true) { where(training_team: status) }
  scope :foster_mentor,           -> (status = true) { where(foster_mentor: status) }
  scope :translator,              -> (status = true) { where(translator: status) }
  scope :public_relations,        -> (status = true) { where(public_relations: status)}
  scope :fundraising,             -> (status = true) { where(fundraising: status)}
  scope :medical_behavior,        -> (status = true) { where(medical_behavior_permission: status)}
  scope :boarding_buddy,          -> (status = true) { where(boarding_buddies: status)}
  scope :social_media,            -> (status = true) { where(social_media_manager: status)}
  scope :graphic_designer,        -> (status = true) { where(graphic_design: status)}
  scope :active_volunteer,        -> (status = true) { where(active: status)}
  scope :inactive_volunteer,      -> (status = false) { where(active: status)}
  scope :house_type,              -> (type) { where(house_type: type) }
  scope :has_dogs,                -> (status = true) { where(has_own_dogs: status) }
  scope :has_cats,                -> (status = true) { where(has_own_cats: status) }
  scope :has_fence,               -> (status = true) { where(has_fenced_yard: status) }
  scope :has_children_under_five, -> (status = true) { where(children_under_five: status) }
  scope :puppies_ok,              -> (status = true) { where(can_foster_puppies: status) }
  scope :has_parvo_house,         -> (status = true) { where(parvo_house: status) }

  def display_name
    name
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by(id: id)
    user && user.salt == cookie_salt ? user : nil
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
    UserSubscribeJob.perform_later(name, email)
  end

  def chimp_unsubscribe
    UserUnsubscribeJob.perform_later(email)
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

    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end

    def full_street_address
      [address1, address2, city, region, postal_code].compact.join(', ')
    end

    def format_cleanup
      region.upcase!
      email.downcase!
    end

    def sanitize_postal_code
      return if postal_code.blank?
      self.postal_code = postal_code.delete(' ').upcase
    end

    def sanitize_region
      return if region.blank?
      self.region = region.delete(' ').upcase
    end

    def country_is_supported
      country = ISO3166::Country.find_country_by_alpha3(self.country)
      if country.nil?
        errors.add(:country, "is not recognized.")
        return
      end

      unless CountryService.supported_country? country
        errors.add(:country, "is not supported. Must be one of: #{CountryService.supported_country_names.join(', ')}.")
      end
    end
end
