class AdoptersController < ApplicationController

	before_filter :authenticate, :except => [:new, :create, :check_email]
	
	before_filter :edit_my_adopters_user, :only => [:index, :show, :edit, :update]
	before_filter :edit_all_adopters_user, :only => [:index, :show, :edit, :update]
	before_filter :admin_user,   :only => [:destroy]

	respond_to :html, :json

  def index
    @title = "Adoption Applications"

	if params[:status] == 'active'
		statuses = ['new', 'pend response', 'workup', 'approved']
		@adopters = Adopter.where("status IN (?)", statuses).includes(:user, :comments, :dogs, :adoption_app)
		# @adopters = Adopter.find(:all, :include => [:user, :comments, :dogs, :adoption_app], :conditions => ["status IN ?", statuses])
	elsif params.has_key? :status
		@adopters = Adopter.where(:status => params[:status]).includes(:user, :comments, :dogs, :adoption_app)
    else
    	@adopters = Adopter.find(:all, :include => [:user, :comments, :dogs, :adoption_app])
    end

    # @adopters = Adopter.paginate(:page => params[:page])
  end


	def show
	  @adopter = Adopter.find(params[:id])
	  @adoption_app = @adopter.adoption_app
	  @title = @adopter.name
	  @adopter_users = User.where(:edit_my_adopters => true)
	end

	def new
		@title = "Adoption Application"
		@adopter = Adopter.new
		@adopter.adoption_app = AdoptionApp.new
		3.times do
			@adopter.references.build
		end
	end

	def create
		@adopter = Adopter.new(params[:adopter])
		@adopter.status = 'new'

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

	def update
		@adopter = Adopter.find(params[:id])
		@adopter.update_attributes(params[:adopter])
		flash[:success] = "Application Updated"
		respond_with @adopter
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
