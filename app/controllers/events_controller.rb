class EventsController < ApplicationController

	before_filter :admin_user, 	:except => [:index, :show]

	def index
		@title = "Upcoming Events"
		@events = Event.all
	end

	def show
		@title = "Events"
		@event = Event.find(params[:id])
	end

	def new
		@title = "Add an Event"
		@event = Event.new
	end

	def edit
		@title = "Edit Event"
		@event = Event.find(params[:id])
	end

	def update
		@event = Event.find(params[:id])
	    if @event.update_attributes(params[:event])
	      flash[:success] = "Event updated."
	      redirect_to events_path
	    else
	      @title = "Edit Event"
	      render 'edit'
	    end
	end

	def create
		@event = Event.new(params[:event])
		if @event.save
			flash[:success] = "New Event Added"
			redirect_to events_path
		else
			@title = "Add an Event"
			render 'new'
		end
	end

	def destroy
		@title = "Events"
		Event.find(params[:id]).destroy
		flash[:danger] = "Event Deleted"
		redirect_to events_path
	end


	private 

		def admin_user
			redirect_to(root_path) unless is_admin?
		end


end
