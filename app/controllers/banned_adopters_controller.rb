class BannedAdoptersController < ApplicationController

	before_filter :authenticate
	before_filter :admin_user, :only => [:new, :create, :destroy, :edit, :update, :import]


	def index
		@title = "Do Not Adopt List"
		@banned_adopters = BannedAdopter.order(:id)
		respond_to do |format|
			format.html
			format.xls {send_data @banned_adopters.to_xls(:filename => 'banned_adopters.xls', :columns => [:id, :name, :phone, :email, :city, :state, :comment], :headers => ['id', 'Name', 'Phone Number', 'Email Address', 'City', 'State', 'Comment'])}
		end
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
		@title = "Edit"
		@banned_adopter = BannedAdopter.find(params[:id])
	end

	def update
		@banned_adopter = BannedAdopter.find(params[:id])
	    if @banned_adopter.update_attributes(params[:banned_adopter])
	      flash[:success] = "Record updated."
	      redirect_to banned_adopters_path
	    else
	      @title = "Edit"
	      render 'edit'
	    end
	end

	def import
		BannedAdopter.import(params[:file])
		flash[:success] = "Banned Adopter List Imported."
		redirect_to banned_adopters_path
	end


	private

		def admin_user
    		redirect_to(root_path) unless current_user.admin?
    	end

end
