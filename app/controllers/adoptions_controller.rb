class AdoptionsController < ApplicationController

	before_filter :edit_my_adopters_user, :only => [:update]
	before_filter :edit_all_adopters_user, :only => [:update]

	respond_to :html, :json


	def create
		# @adopter = Adopter.find(params[:adoption][:adopter_id])
	    @adoption = Adoption.new(params[:adoption])
	    @adoption.relation_type = 'interested'
	    if @adoption.save
	      flash[:success] = "Dogs linked to Application"
	    end
	    redirect_to :back
	end

	def update
		@adoption = Adoption.find(params[:id])
		@adoption.update_attributes(params[:adoption])
		respond_with @adopter
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
