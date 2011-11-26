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

		if @adopter.save
			@adopter.adoptions.each do |a|
				a.relation_type = 'interested'
				a.save
			end
			flash[:success] = "Adopter Created"
			redirect_to root_path
		else
			render 'new'
		end
	end
end
