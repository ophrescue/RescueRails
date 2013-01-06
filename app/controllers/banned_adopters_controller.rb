class BannedAdoptersController < ApplicationController

	before_filter :authenticate
	before_filter :admin_user, :only => [:new, :create, :destroy, :edit, :update]


	def index
		@title = "Do Not Adopt List"
		@banned_adopters = BannedAdopter.find(:all)

	end

	def show
		@banned_adopter = BannedAdopter.find(params[:id])
		@title = @banned_adopter.name
	end

	def new
		@title = "Add a Banned Adopter"
		@banned_adopter = BannedAdopter.new
	end

	def create
		@banned_adopter = BannedAdopter.new(params[:banned_adopter])
		if @banned_adopter.save
			flash[:success] = "New Banned Adopter Added"
			redirect_to banned_adopters_path
		else
			@title = "Add an Banend Adopter"
			render 'new'
		end
	end


	def edit

	end

	def update
		
	end

	def destroy

	end


	private

		def admin_user
    		redirect_to(root_path) unless current_user.admin?
    	end

end
