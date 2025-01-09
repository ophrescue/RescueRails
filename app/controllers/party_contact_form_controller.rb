class PartyContactFormController < ApplicationController
  before_action :select_bootstrap41

  def create
    @name = params[:party_contact_form][:name]
    @email = params[:party_contact_form][:email]
    @phone = params[:party_contact_form][:phone]
    @organization = params[:party_contact_form][:organization]
    @event_date_and_time = params[:party_contact_form][:event_date_and_time]
    @event_location = params[:party_contact_form][:event_location]
    @event_description = params[:party_contact_form][:event_description]
    @guest_count = params[:party_contact_form][:guest_count]
    @event_details = params[:party_contact_form][:event_details]


    PartyMailer.notify(@name, @email, @phone, @organization, @event_date_and_time, @event_location, @event_description, @guest_count, @event_details).deliver_later

    flash[:success] = "Your message has been sent successfully. An OPH representative will be in touch with you to discuss your request."
    redirect_to :root
  end

  private
  #  def party_contact_form
  #   params.require(:party_contact_form).permit(:name,
  #                 :email,
  #                 :phone,
  #                 :organization,
  #                 :event_date_and_time,
  #                 :event_location,
  #                 :event_description,
  #                 :guest_count,
  #                 :event_details
  #   )
  #  end

end
