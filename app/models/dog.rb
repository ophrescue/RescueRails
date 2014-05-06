# == Schema Information
#
# Table name: dogs
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  created_at           :timestamp(6)
#  updated_at           :timestamp(6)
#  tracking_id          :integer
#  primary_breed_id     :integer
#  secondary_breed_id   :integer
#  status               :string(255)
#  age                  :string(75)
#  size                 :string(75)
#  is_altered           :boolean
#  gender               :string(6)
#  is_special_needs     :boolean
#  no_dogs              :boolean
#  no_cats              :boolean
#  no_kids              :boolean
#  description          :text
#  foster_id            :integer
#  adoption_date        :date
#  is_uptodateonshots   :boolean          default(TRUE)
#  intake_dt            :date
#  available_on_dt      :date
#  has_medical_need     :boolean          default(FALSE)
#  is_high_priority     :boolean          default(FALSE)
#  needs_photos         :boolean          default(FALSE)
#  has_behavior_problem :boolean          default(FALSE)
#  needs_foster         :boolean          default(FALSE)
#  petfinder_ad_url     :string(255)
#  adoptapet_ad_url     :string(255)
#  craigslist_ad_url    :string(255)
#  youtube_video_url    :string(255)
#  first_shots          :string(255)
#  second_shots         :string(255)
#  third_shots          :string(255)
#  rabies               :string(255)
#  heartworm            :string(255)
#  bordetella           :string(255)
#  microchip            :string(255)
#  original_name        :string(255)
#  fee                  :integer
#  coordinator_id       :integer
#  sponsored_by         :string(255)
#

class Dog < ActiveRecord::Base

	attr_accessor   :primary_breed_name,
					:secondary_breed_name

	attr_accessible :name, 
					:tracking_id, 
					:primary_breed_id,
					:primary_breed_name,
					:secondary_breed_id,
					:secondary_breed_name,
					:status,
					:age,
					:size,
					:is_altered,
					:gender,
					:is_special_needs,
					:no_dogs,
					:no_cats,
					:no_kids,
					:description,
					:photos_attributes,
					:foster_id,
					:foster_start_date,
					:adoption_date,
					:is_uptodateonshots,
					:intake_dt,
					:available_on_dt,
					:has_medical_need,
					:is_high_priority,
					:needs_photos,    
					:has_behavior_problem,
					:needs_foster,
					:attachments_attributes,
					:petfinder_ad_url,
					:adoptapet_ad_url,
					:craigslist_ad_url,
					:youtube_video_url,
					:first_shots,
					:second_shots,
					:third_shots,
					:rabies,
					:heartworm,
					:bordetella,
					:microchip,
					:original_name,
					:fee,
					:coordinator_id,
					:sponsored_by,
					:shelter_id


	belongs_to :primary_breed, :class_name => 'Breed'
	belongs_to :secondary_breed, :class_name => 'Breed'

    has_many :comments, :as => :commentable, :order => "created_at DESC"

    has_many :attachments, :as => :attachable, :dependent => :destroy
    accepts_nested_attributes_for :attachments, :allow_destroy => true

	has_many :photos, :dependent => :destroy, :order => "position"
	accepts_nested_attributes_for :photos, :allow_destroy => true

	belongs_to :foster, :class_name => "User"
	belongs_to :coordinator, :class_name => "User"	

	has_many :adoptions, :dependent => :destroy
	has_many :adopters, :through => :adoptions

	belongs_to :shelter

	validates :name, :presence => true,
					 :length   => { :maximum => 75 },
					 :uniqueness => { :case_sensitive => false }

	validates :tracking_id, :uniqueness => true,
							:presence => true

	validates_presence_of :status

  scope :not_associated, -> { where('id NOT IN (select dog_id from adoptions)') }

	STATUSES = ['adoptable', 'adopted', 'adoption pending',
				'on hold', 'not available', 'return pending', 'coming soon', 'completed']
	validates_inclusion_of :status, :in => STATUSES

	AGES = ['baby', 'young', 'adult', 'senior']		
	validates_inclusion_of :age, :in => AGES, :allow_blank => true

	SIZES = ['small', 'medium', 'large','extra large']	
	validates_inclusion_of :size, :in => SIZES, :allow_blank => true
	
	GENDERS = ['Male', 'Female']
	validates_inclusion_of :gender, :in => GENDERS, :allow_blank => true


	before_save :update_adoption_date



	def update_adoption_date
		return unless self.status_changed?
		return unless self.status != 'completed'

		if (self.status == 'adopted')
			self.adoption_date = Date.today()
		else
			self.adoption_date = nil
		end

	end

end




