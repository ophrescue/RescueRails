class AdoptersController < ApplicationController
  include SessionsHelper

  before_filter :authenticate, :except => [:new, :create, :check_email]
  before_filter :edit_my_adopters_user, :only => [:index, :show, :edit, :update]
  before_filter :edit_all_adopters_user, :only => [:index, :show, :edit, :update]
  before_filter :admin_user, :only => [:destroy]
  before_filter :load_adopter, only: %i(show update)

  respond_to :html, :json

  def index
    @title = "Adoption Applications"
    session[:last_search] = request.url
    @adopters = AdopterSearcher.search(params: params)
  end

  def show
    @title = @adopter.name
    session[:last_search] ||= adopters_url
    @adoption_app = @adopter.adoption_app
    @dogs_all = Dog.order("name").all
    @adoption = Adoption.new
    @adopter_users = User.where(:edit_my_adopters => true).order("name")
  end

  def new
    @title = "Adoption Application"
    @adopter = Adopter.new
    @adopter.adoption_app = AdoptionApp.new
    @adopter.dog_name = params[:dog_name]
    3.times do
      @adopter.references.build
    end
  end

  def create
    @adopter = Adopter.new(params[:adopter])
    @adopter.status = 'new'

    if !@adopter.adoption_app.ready_to_adopt_dt
      @adopter.adoption_app.ready_to_adopt_dt = Date.today
    end

    if @adopter.save
      @adopter.adoptions.each do |a|
        a.relation_type = 'interested'
        a.save
      end

      NewAdopterMailer.adopter_created(@adopter.id).deliver
      AdoptAppMailer.adopt_app(@adopter.id).deliver
      flash[:success] = "adoptsuccess"
      redirect_to root_path(:adoptapp => "complete")
    else
      render 'new'
    end
  end

  def update
    if (params[:adopter][:status] == 'completed') && (!can_complete_adopters?)
      flash[:error] = "You are not allowed to set an application to completed"
    else
      @adopter.updated_by_admin_user = current_user
      @adopter.update_attributes(params[:adopter])
      flash[:success] = "Application Updated"
    end

    respond_with(@adopter) do |format|
      format.html { render }
      format.json { render json: @adopter }
    end
  end

  def check_email
    adopter_exists = Adopter.where(email: params[:adopter][:email]).exists?

    respond_to do |format|
      format.json { render :json => !adopter_exists }
    end
  end

  private

  def load_adopter
    @adopter = Adopter.find(params[:id])
  end

  def edit_my_adopters_user
    #TODO Figure out how to differentiate these
    redirect_to(root_path) unless current_user.edit_my_adopters? || current_user.edit_all_adopters?
  end

  def edit_all_adopters_user
    #TODO Figure out how to differentiate these
    redirect_to(root_path) unless current_user.edit_all_adopters?
  end
end
