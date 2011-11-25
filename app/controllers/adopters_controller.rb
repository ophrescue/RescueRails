class AdoptersController < ApplicationController

	before_filter :authenticate, :except => [:new, :create]
	before_filter :admin_user,   :only => [:destroy]


  def index
    @title = "Adoption Applications"
    @adopters = Adopter.paginate(:page => params[:page])
  end

  def show
    @adopter = Adopter.find(params[:id])
    @title = @adopter.name
  end

	def new
		@adopter = Adopter.new
		@adopter.adoption_app = AdoptionApp.new
		3.times do
			@adopter.references.build
		end
	end

	def create
		@adopter = Adopter.new(params[:adopter])
		@adopter.status = 'pending'


		@adopter.dogs.each do |d|
			d.adoptions.each do |a|
				a.type = 'interested'
			end
		end
		if @adopter.save
			flash[:success] = "Adopter Created"
			redirect_to root_path
		else
			render 'new'
		end
	end
end
