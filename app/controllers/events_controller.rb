class EventsController < ApplicationController


  before_filter :edit_events_user,  :except => [:index, :show]

  def index
    @title = "Upcoming Events"
    @events = Event.find(:all,
               :conditions => ["event_date >= ?", Date.today],
               :limit => 30, 
               :order => 'event_date')
  end

  def past
    @title = "Past Events"
    @events = Event.find(:all,
               :conditions => ["event_date <= ?", Date.today],
               :limit => 30, 
               :order => 'event_date')
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
    @event.photo_delete = params[:event][:photo_delete]
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

      def edit_events_user
        redirect_to(root_path) unless current_user.edit_events?
      end

end
