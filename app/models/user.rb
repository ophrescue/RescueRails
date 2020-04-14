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
#  name                         :string
#  email                        :string
#  created_at                   :datetime
#  updated_at                   :datetime
#  encrypted_password           :string
#  salt                         :string
#  admin                        :boolean          default(FALSE)
#  password_reset_token         :string
#  password_reset_sent_at       :datetime
#  is_foster                    :boolean          default(FALSE)
#  phone                        :string
#  address1                     :string
#  address2                     :string
#  city                         :string
#  region                       :string(2)
#  postal_code                  :string
#  duties                       :string
#  edit_dogs                    :boolean          default(FALSE)
#  share_info                   :text
#  edit_my_adopters             :boolean          default(FALSE)
#  edit_all_adopters            :boolean          default(FALSE)
#  locked                       :boolean          default(FALSE)
#  edit_events                  :boolean          default(FALSE)
#  other_phone                  :string
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
#  medical_behavior_permission  :boolean          default(FALSE)
#  boarding_buddies             :boolean          default(FALSE), not null
#  social_media_manager         :boolean          default(FALSE), not null
#  graphic_design               :boolean          default(FALSE), not null
#  country                      :string(3)        not null
#  active                       :boolean          default(FALSE), not null
#  confirmation_token           :string(128)
#  remember_token               :string(128)
#  avatar_file_name             :string
#  avatar_content_type          :string
#  avatar_file_size             :integer
#  avatar_updated_at            :datetime
#

class User < ApplicationRecord
  audited only: %i[admin edit_dogs edit_my_adopters edit_all_adopters locked edit_events complete_adopters add_dogs ban_adopters dl_resources dl_locked_resources active admin_comment medical_behavior_permission], on: [:update]
  include Clearance::User
  include Filterable

  attr_accessor :accessible

  strip_attributes only: :email

  validates :name,  presence: true,
                    length: { maximum: 50 }

  validates :country, length: { is: 3 }
  validate :country_is_supported

  validates :password,
            presence: true,
            confirmation: true,
            length: { within: 8..40 },
            unless: :skip_password_validation?

  validates_with RegionValidator
  validates_with PostalCodeValidator

  geocoded_by :full_street_address
  after_validation :geocode

  has_many :foster_cats, class_name: 'Cat', foreign_key: 'foster_id'
  has_many :current_foster_cats, -> { where(status: ['adoptable', 'adoption pending', 'on hold', 'coming soon', 'return pending']) }, class_name: 'Cat', foreign_key: 'foster_id'

  has_many :foster_dogs, class_name: 'Dog', foreign_key: 'foster_id'
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

  scope :inactive_volunteer,      -> (status = false) { where(active: status)}
  scope :house_type,              -> (type) { where(house_type: type) }

  HASH_SECRET = "5b0a2cd2064828d34ad737f9f6a586fb773297a01639c2b3ff24fcb7"
  has_attached_file :avatar, styles: { thumb: "75x75>",
                                       medium: "300x300>" },
                             s3_permissions: "public-read",
                             hash_secret: HASH_SECRET,
                             default_url: "no_profile_photo.png"

  PAPERCLIP_STORAGE_PATH = { test: "/system/test/user_photo/:hash.:extension",
                             production: "/user_photo/:hash.:extension",
                             staging: "/user_photo/:hash.:extension" }

  CONTENT_TYPES = {"Images" => ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/png', 'image/x-png', 'image/gif']}

  MIME_TYPES = CONTENT_TYPES.values.flatten

  validates_attachment_content_type :avatar,
                                    content_type: MIME_TYPES,
                                    message: 'Images Only.'
  PHOTO_MAX_SIZE = 5
  validates_attachment_size :avatar, less_than: PHOTO_MAX_SIZE.megabytes

  HOUSE_TYPES = %w[ rent own ]

  # mapping of scope name (= query string parameter) to model attributes
  FILTER_FLAGS = { active_volunteer: :active,
                   admin: :admin,
                   adoption_coordinator: :edit_my_adopters,
                   available_to_foster: :available_to_foster,
                   boarding_buddy: :boarding_buddies,
                   dog_adder: :add_dogs,
                   dog_editor: :edit_dogs,
                   event_planner: :edit_events,
                   foster: :is_foster,
                   foster_mentor: :foster_mentor,
                   fundraising: :fundraising,
                   graphic_designer: :graphic_design,
                   has_cats: :has_own_cats,
                   has_children_under_five: :children_under_five,
                   has_dogs: :has_own_dogs,
                   has_fence: :has_fenced_yard,
                   has_parvo_house: :parvo_house,
                   medical_behavior: :medical_behavior_permission,
                   newsletter: :writes_newsletter,
                   photographer: :is_photographer,
                   public_relations: :public_relations,
                   puppies_ok: :can_foster_puppies,
                   social_media: :social_media_manager,
                   training_team: :training_team,
                   translator: :translator,
                   transporter: :is_transporter }

  FILTER_FLAGS.each do |param,attr|
    scope :"#{param}", -> (status = true) { where "#{attr}": status}
  end

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

  def location
    has_location? && "#{city.titleize}, #{region.upcase}".html_safe
  end

  def has_location?
    [city, region].all?
  end

  def audits_sorted
    audits.sort_by(&:created_at).reverse!
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
