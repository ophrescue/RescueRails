class NewAdopterMailer < ActionMailer::Base
	default :from => "Operation Paws for Homes <info@ophrescue.org>" ,
			:return_path => 'admin@ophrescue.org',
			:reply_to => 'adopt@ophrescue.org'

  def adopter_created(adopter_id)
  	@adopter = Adopter.find(adopter_id)
  	@destination_email = Rails.env.production? ? "#{@adopter.name} <#{@adopter.email}>" : "admin@ophrescue.org"
  	mail(:to => @destination_email,
    	 :subject =>     "Adoption Application Received!",
    	 :content_type => "text/html")
  end
end
