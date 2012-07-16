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
					:user_id,
					:foster_start_date,
					:adoption_date,
					:is_uptodateonshots,
					:is_housetrained,
					:intake_dt,
					:available_on_dt,
					:has_medical_need,
					:is_high_priority,
					:needs_photos,    
					:has_behavior_problem,
					:needs_foster,
					:attachments_attributes


	belongs_to :primary_breed, :class_name => 'Breed'
	belongs_to :secondary_breed, :class_name => 'Breed'

    has_many :comments, :as => :commentable, :order => "created_at DESC"

    has_many :attachments, :as => :attachable, :dependent => :destroy
    accepts_nested_attributes_for :attachments, :allow_destroy => true

	has_many :photos, :dependent => :destroy
	accepts_nested_attributes_for :photos, :allow_destroy => true

	has_many :histories, :dependent => :destroy
	
	has_many :users, :through => :history
	belongs_to :user

	has_many :adoptions, :dependent => :destroy
	has_many :adopters, :through => :adoptions

	before_save   :set_dates

	before_update :update_history

	validates :name, :presence => true,
					 :length   => { :maximum => 75 },
					 :uniqueness => { :case_sensitive => false }

	validates :tracking_id, :uniqueness => true,
							:presence => true

	validates_presence_of :status


	STATUSES = ['adoptable', 'adopted', 'adoption pending',
				'hold', 'not available', 'return pending', 'coming soon']
	validates_inclusion_of :status, :in => STATUSES

	AGES = ['baby', 'young', 'adult', 'senior']		
	validates_inclusion_of :age, :in => AGES, :allow_blank => true

	SIZES = ['small', 'medium', 'large','extra large']	
	validates_inclusion_of :size, :in => SIZES, :allow_blank => true
	
	GENDERS = ['Male', 'Female']
	validates_inclusion_of :gender, :in => GENDERS, :allow_blank => true


	def update_history
		if self.user_id != Dog.find(self.id).user_id
			#TODO move to the History model.
			@history = History.new
			@history.dog_id = self.id
			@history.user_id = self.user_id
			@history.foster_start_date = self.foster_start_date
			@history.foster_end_date = Time.now.strftime('%Y-%m-%d')
			@history.save
		end
	end

	def set_dates
      if (self.status == 'adopted')
      	self.user_id = nil
      	self.foster_start_date = nil
      else
      	self.foster_start_date = Time.now.strftime('%Y-%m-%d')
      	self.adoption_date = nil
      end
    end

end



# == Schema Information
#
# Table name: dogs
#
#  id                   :integer         not null, primary key
#  name                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
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
#  user_id              :integer
#  foster_start_date    :date
#  adoption_date        :date
#  is_uptodateonshots   :boolean         default(TRUE)
#  is_housetrained      :boolean         default(TRUE)
#  intake_dt            :date
#  available_on_dt      :date
#  has_medical_need     :boolean         default(FALSE)
#  is_high_priority     :boolean         default(FALSE)
#  needs_photos         :boolean         default(FALSE)
#  has_behavior_problem :boolean         default(FALSE)
#  needs_foster         :boolean         default(FALSE)
#

