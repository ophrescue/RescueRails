# == Schema Information
#
# Table name: dogs
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  tracking_id        :integer
#  primary_breed_id   :integer
#  secondary_breed_id :integer
#  status             :string(255)
#  age                :string(75)
#  size               :string(75)
#  is_altered         :boolean
#  gender             :string(6)
#  is_special_needs   :boolean
#  no_dogs            :boolean
#  no_cats            :boolean
#  no_kids            :boolean
#  description        :text
#  is_purebred        :boolean
#

class Dog < ActiveRecord::Base

	attr_accessor   :primary_breed_name,
					:secondary_breed_name

	attr_accessible :name, 
					:tracking_id, 
					:primary_breed_id,
					:secondary_breed_id,
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
					:is_purebred

	belongs_to :primary_breed, :class_name => 'Breed'
	belongs_to :secondary_breed, :class_name => 'Breed'

	has_many :photos

	accepts_nested_attributes_for :photos

	validates :name, :presence => true,
					 :length   => { :maximum => 75 }

	validates :tracking_id, :uniqueness => true,
							:presence => true

	validates_presence_of :primary_breed_id,
						  :status,
						  :age,
						  :size,
						  :gender

	STATUSES = ['adoptable', 'adopted', 'adoption pending',
				'hold', 'not available', 'return pending']
	validates_inclusion_of :status, :in => STATUSES	

	AGES = ['baby', 'young', 'adult', 'senior']		
	validates_inclusion_of :age, :in => AGES	

	SIZES = ['small', 'medium', 'large','extra large']	
	validates_inclusion_of :size, :in => SIZES
	
	GENDERS = ['Male', 'Female']
	validates_inclusion_of :gender, :in => GENDERS

end

