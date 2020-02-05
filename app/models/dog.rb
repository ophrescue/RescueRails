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
# Table name: dogs
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  tracking_id             :integer
#  primary_breed_id        :integer
#  secondary_breed_id      :integer
#  status                  :string(255)
#  age                     :string(75)
#  size                    :string(75)
#  is_altered              :boolean
#  gender                  :string(6)
#  is_special_needs        :boolean
#  no_dogs                 :boolean
#  no_cats                 :boolean
#  no_kids                 :boolean
#  description             :text
#  foster_id               :integer
#  adoption_date           :date
#  is_uptodateonshots      :boolean          default(TRUE)
#  intake_dt               :date
#  available_on_dt         :date
#  has_medical_need        :boolean          default(FALSE)
#  is_high_priority        :boolean          default(FALSE)
#  needs_photos            :boolean          default(FALSE)
#  has_behavior_problem    :boolean          default(FALSE)
#  needs_foster            :boolean          default(FALSE)
#  petfinder_ad_url        :string(255)
#  craigslist_ad_url       :string(255)
#  youtube_video_url       :string(255)
#  first_shots             :string(255)
#  second_shots            :string(255)
#  third_shots             :string(255)
#  rabies                  :string(255)
#  vac_4dx                 :string(255)
#  bordetella              :string(255)
#  microchip               :string(255)
#  original_name           :string(255)
#  fee                     :integer
#  coordinator_id          :integer
#  sponsored_by            :string(255)
#  shelter_id              :integer
#  medical_summary         :text
#  heartworm_preventative  :string
#  flea_tick_preventative  :string
#  medical_review_complete :boolean          default(FALSE)
#  behavior_summary        :text
#  dewormer                :string
#  toltrazuril             :string
#

class Dog < ApplicationRecord
  audited
  include Filterable
  include Flaggable
  include ClientValidated

  attr_accessor :primary_breed_name, :secondary_breed_name

  has_associated_audits

  belongs_to :primary_breed, class_name: 'Breed'
  belongs_to :secondary_breed, class_name: 'Breed'
  belongs_to :foster, class_name: 'User'
  belongs_to :coordinator, class_name: 'User'
  belongs_to :shelter

  has_many :comments, -> { order 'created_at DESC' }, as: :commentable
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :photos, -> { order 'position ASC' }, dependent: :destroy, as: :animal
  has_many :adoptions, dependent: :destroy
  has_many :adopters, through: :adoptions

  accepts_nested_attributes_for :attachments, allow_destroy: true
  accepts_nested_attributes_for :photos, allow_destroy: true

  validates :name, presence: true,
           length: { maximum: 75 },
           uniqueness: { case_sensitive: false }

  validates :tracking_id, uniqueness: true, presence: true

  STATUSES = ['adoptable', 'adopted', 'adoption pending', 'trial adoption',
        'on hold', 'not available', 'return pending', 'coming soon', 'completed']
  validates_inclusion_of :status, in: STATUSES
  validates_presence_of :status

  # map standard validation messages onto attributes
  VALIDATION_ERROR_MESSAGES = {tracking_id: :numeric, name: :blank, status: :selected }

  PUBLIC_STATUSES = ['adoptable', 'adoption pending', 'coming soon'].freeze

  ACTIVE_STATUSES = [
    'adoptable',
    'adoption pending',
    'on hold',
    'return pending',
    'coming soon'
  ]

  UNAVAILABLE_STATUSES = ['adopted', 'completed', 'not available']

  PETFINDER_STATUS = {
    'adoptable' => 'A',
    'adoption pending' => 'P',
    'on hold' => 'H',
    'return pending' => 'H',
    'coming soon' => 'H'
  }.freeze

  PETFINDER_SIZE = {
    'small' => 'S',
    'medium' => 'M',
    'large' => 'L',
    'extra large' => 'XL'
  }.freeze

  PETFINDER_GENDER = {
    'Male' => 'M',
    'Female' => 'F'
  }.freeze

  AGES = %w[baby young adult senior]
  validates_inclusion_of :age, in: AGES, allow_blank: true

  SIZES = ['small', 'medium', 'large', 'extra large']
  validates_inclusion_of :size, in: SIZES, allow_blank: true

  GENDERS = %w[Male Female]
  validates_inclusion_of :gender, in: GENDERS, allow_blank: true

  SEARCH_FIELDS = ["Breed", "Tracking ID", "Name", "Microchip"]

  before_save :update_adoption_date, :update_needs_foster

  scope :is_breed,                                ->(breed_partial) { joins("join breeds on (breeds.id = dogs.primary_breed_id) or (breeds.id = dogs.secondary_breed_id)").where("breeds.name ilike '%#{sanitize_sql_like(breed_partial)}%'").distinct }
  scope :pattern_matching_name,                   ->(search_term) { where("name ilike ?", search_term) }

  # Rails 5.2 issues deprecation errors for any order that is not column names
  # so arel is the workaround
  scope :sort_with_search_term_matches_first,     ->(search_term) { order(Dog.arel_table[:name].does_not_match("#{search_term}%"), "tracking_id asc") }
  scope :gallery_view,                            -> { includes(:primary_breed, :secondary_breed, :photos, :foster).where(status: Dog::PUBLIC_STATUSES).status_order.order(:tracking_id) }

  def self.autocomplete_name(search_term = nil)
    if search_term.present?
      select(:name, :id)
        .pattern_matching_name("%"+search_term+"%")
        .sort_with_search_term_matches_first(search_term)
    else
      select(:name, :id)
    end
  end

  def self.search(search_params)
    search_term, search_field = search_params
    return unscoped if invalid_search_params(search_params)
    return is_breed(search_term) if search_field == "breed"
    return where("#{search_field} = ?", "#{search_term.strip}") if search_field == "tracking_id"
    return where("#{search_field} ilike ?", "%#{search_term.strip}%")
  end

  def self.invalid_search_params(search_params)
    search_term, search_field = search_params
    # security check, since search field will be injected into SQL query
    (search_params.compact.length != 2) || ( !%w(name tracking_id microchip breed).include? search_field )
  end

  def name=(name)
    write_attribute(:name, name.strip)
  end

  def breeds
    [ (primary_breed&.name), (secondary_breed&.name) ].compact
  end

  def primary_photo_url
    if Rails.env.development?
      # helps with formulating the css, and UI design, on the DogsController#index page
      # shouldn't be used longterm, as it uses actual urls, which will expire in time.
      # it would be good to have a longterm solution that has actual photos
      AWS_PHOTO_URLS.sample()
    else
      photos.empty? ?
        Photo.no_photo_url :
        photos.visible.first.photo.url(:medium)
    end
  end

  def primary_breed_name
    primary_breed&.name
  end

  def secondary_breed_name
    secondary_breed&.name
  end

  def photo_alt_text
    primary_breed ?  primary_breed.name : name
  end

  def foster_location
    foster && foster.location
  end

  def adopted?
    status == 'adopted'
  end

  def status_key
    status.gsub(/\s/,"_")
  end

  def unavailable?
    UNAVAILABLE_STATUSES.include?(status)
  end

  def is_accepting_applications?
    PUBLIC_STATUSES.include?(status)
  end

  def attributes_to_audit
    %w[status]
  end

  def audits_and_associated_audits
    (audits + associated_audits).sort_by(&:created_at).reverse!
  end

  def comments_and_audits_and_associated_audits
    (persisted_comments + audits + associated_audits).sort_by(&:created_at).reverse!
  end

  def self.status_order
    order(Arel.sql("
      CASE
        WHEN status = 'adoptable' THEN '1'
        WHEN status = 'coming soon' THEN '2'
        WHEN status = 'adoption pending' THEN '3'
      END
      "))
  end

  def to_petfinder_status
    PETFINDER_STATUS[status]
  end

  def to_petfinder_size
    PETFINDER_SIZE[size]
  end

  def to_petfinder_gender
    PETFINDER_GENDER[gender]
  end

  def update_adoption_date
    return unless status_changed?
    return if status == 'completed'

    self.adoption_date = nil
    self.adoption_date = Date.today() if adopted?
  end

  def update_needs_foster
    return unless status_changed?
    return unless ['completed', 'adopted', 'trial adoption'].include?(status)

    self.needs_foster = false
  end

  def self.next_tracking_id
    connection.select_value("SELECT nextval('tracking_id_seq')")
  end

  def persisted_comments
    comments.select(&:persisted?)
  end
end

DogsManager = Dog
