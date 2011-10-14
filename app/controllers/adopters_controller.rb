class AdoptersController < ApplicationController

	def new
		@adopter = Adopter.new
	end

	def create
		@adopter = Adopter.new(params[:adopter])
		@adopter.save
	end
end
