class NewAdopterMailer < ActionMailer::Base
	default :from => "Operation Paws for Homes <info@ophrescue.org>" ,
			:return_path => 'admin@ophrescue.org',
			:reply_to => 'adopt@ophrescue.org'

  def adopter_created(adopter_id)
  	@adopter = Adopter.find(adopter_id)
  	mail(:to => "#{@adopter.name} <#{@adopter.email}>" ,
    	 :subject =>     "Adoption Application Received!",
    	 :content_type => "text/html")
  end
end
