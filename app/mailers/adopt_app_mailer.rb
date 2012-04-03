class AdoptAppMailer < ActionMailer::Base
	default :from => "Operation Paws for Homes <info@ophrescue.org>" ,
			:return_path => 'adopt@ophrescue.org',
			:reply_to => 'adopt@ophrescue.org'

  def adopt_app(adopter)
  	@adopter = adopter
  	mail(:to => "adopt@ophrescue.org",
  		 :reply_to => "#{adopter.name} <#{adopter.email}>",
       :subject =>     "[app] #{adopter.name} for #{adopter.dog_name} ",
    	 # :subject =>     "[app] #{adopter.name} for #{adopter.dog_name} on #{adopter.adoption_app.ready_to_adopt_dt}",
    	 :content_type => "text/html")
  end
end
