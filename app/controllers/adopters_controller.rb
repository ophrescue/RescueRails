class AdoptersController < ApplicationController

	before_filter :authenticate, :except => [:new, :create, :check_email]
	
	before_filter :edit_my_adopters_user, :only => [:index, :show, :edit, :update]
	before_filter :edit_all_adopters_user, :only => [:index, :show, :edit, :update]
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
			NewAdopterMailer.adopter_created(@adopter).deliver
			AdoptAppMailer.adopt_app(@adopter).deliver
			flash[:success] = "adoptsuccess"
			redirect_to root_path
		else
			render 'new'
		end
	end

	def check_email
		@adopter = Adopter.find_by_email(params[:adopter][:email])

		respond_to do |format|
			format.json { render :json => !@adopter }
		end
	end

	private

	    def edit_my_adopters_user
	    #TODO Figure out how to differentiate these
	      redirect_to(root_path) unless current_user.edit_my_adopters?
	    end

	    def edit_all_adopters_user
	     #TODO Figure out how to differentiate these
	      redirect_to(root_path) unless current_user.edit_all_adopters?
	    end
	
end
