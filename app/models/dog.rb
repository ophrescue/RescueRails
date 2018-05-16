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
#  adoptapet_ad_url        :string(255)
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
#

class Dog < ApplicationRecord
  audited
  include Filterable

  attr_accessor :primary_breed_name, :secondary_breed_name

  has_associated_audits

  belongs_to :primary_breed, class_name: 'Breed'
  belongs_to :secondary_breed, class_name: 'Breed'
  belongs_to :foster, class_name: 'User'
  belongs_to :coordinator, class_name: 'User'
  belongs_to :shelter

  has_many :comments, -> { order 'created_at DESC' }, as: :commentable
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :photos, -> { order 'position ASC' }, dependent: :destroy
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

  PUBLIC_STATUSES = ['adoptable', 'adoption pending', 'coming soon'].freeze

  ACTIVE_STATUSES = [
    'adoptable',
    'adoption pending',
    'on hold',
    'return pending',
    'coming soon'
  ]

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

  FILTER_FLAGS = [
    'High Priority',
    'Medical Need',
    'Special Needs',
    'Medical Review Needed',
    'Behavior Problems',
    'Foster Needed',
    'Spay Neuter Needed',
    'No Cats',
    'No Dogs',
    'No Kids'
  ]

  AGES = %w[baby young adult senior]
  validates_inclusion_of :age, in: AGES, allow_blank: true

  SIZES = ['small', 'medium', 'large', 'extra large']
  validates_inclusion_of :size, in: SIZES, allow_blank: true

  GENDERS = %w[Male Female]
  validates_inclusion_of :gender, in: GENDERS, allow_blank: true

  before_save :update_adoption_date

  scope :is_age,                                  ->(age) { where age: age }
  scope :is_size,                                 ->(size) { where size: size }
  scope :is_status,                               ->(status) { where status: status }
  scope :is_breed,                                ->(breed_partial) { joins("join breeds on (breeds.id = dogs.primary_breed_id) or (breeds.id = dogs.secondary_breed_id)").where("breeds.name ilike '%#{sanitize_sql_like(breed_partial)}%'").distinct }
  scope :cb_high_priority,                        ->(_) { where is_high_priority: true }
  scope :cb_medical_need,                         ->(_) { where has_medical_need: true }
  scope :cb_medical_review_needed,                ->(_) { where medical_review_complete: false }
  scope :cb_special_needs,                        ->(_) { where is_special_needs: true }
  scope :cb_behavior_problems,                    ->(_) { where has_behavior_problem: true }
  scope :cb_foster_needed,                        ->(_) { where needs_foster: true }
  scope :cb_spay_neuter_needed,                   ->(_) { where is_altered: false }
  scope :cb_no_cats,                              ->(_) { where no_cats: true }
  scope :cb_no_dogs,                              ->(_) { where no_dogs: true }
  scope :cb_no_kids,                              ->(_) { where no_kids: true }

  scope :matching_tracking_id,                    ->(search_term) { where tracking_id: search_term }
  scope :identity_matching_microchip,             ->(search_term) { where microchip: search_term }
  scope :identity_match_tracking_id_or_microchip, ->(search_term){ matching_tracking_id(search_term).or( identity_matching_microchip(search_term)) }

  scope :pattern_matching_microchip,              ->(search_term) { where("microchip ilike ?", search_term) }
  scope :pattern_matching_name,                   ->(search_term) { where("name ilike ?", search_term) }
  scope :pattern_match_microchip_or_name,         ->(search_term){ pattern_matching_microchip("%"+search_term+"%").or( pattern_matching_name("%"+search_term+"%")) }

  # Rails 5.2 issues deprecation errors for any order that is not column names
  # so arel is the workaround
  scope :sort_with_search_term_matches_first,     ->(search_term) { order(Dog.arel_table[:name].does_not_match("#{search_term}%"), "tracking_id asc") }

  scope :gallery_view,                            -> { includes(:primary_breed, :secondary_breed, :photos, :foster).where(status: Dog::PUBLIC_STATUSES).order(:tracking_id) }
  scope :default_manager_view,                    -> { includes(:adoptions, :adopters, :comments, :primary_breed, :secondary_breed, :foster).order(:tracking_id) }
  scope :autocomplete_name,                       ->(search_term){ if search_term.present? then select(:name, :id).pattern_matching_name("%"+search_term+"%").sort_with_search_term_matches_first(search_term) else select(:name, :id) end }

  def breeds
    [ (primary_breed&.name), (secondary_breed&.name) ].compact
  end

  def adopted?
    status == 'adopted'
  end

  def attributes_to_audit
    %w[status]
  end

  def audits_and_associated_audits
    (audits + associated_audits).sort_by(&:created_at).reverse!
  end

  def comments_and_audits_and_associated_audits
    (valid_comments + audits + associated_audits).sort_by(&:created_at).reverse!
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
    return unless status != 'completed'

    self.adoption_date = nil
    self.adoption_date = Date.today() if adopted?
  end

  def self.next_tracking_id
    connection.select_value("SELECT nextval('tracking_id_seq')")
  end

  def valid_comments
    comments.to_a.delete_if { |obj| obj.id.nil? }
  end
end
