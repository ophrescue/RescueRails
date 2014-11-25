class AdoptAppMailer < ActionMailer::Base
  default :from => "Operation Paws for Homes <info@ophrescue.org>" ,
          :return_path => 'adopt@ophrescue.org',
          :reply_to => 'adopt@ophrescue.org'

  def adopt_app(adopter_id)
    @destination_email = Rails.env.production? ? "adopt@ophrescue.org" : "admin@ophrescue.org"
    @adopter = Adopter.find(adopter_id)
    mail(:to => @destination_email,
       :reply_to => "#{@adopter.email}",
       :subject =>     "PLEASE RESPOND #{@adopter.name} for #{@adopter.dog_name} [OPH Adoption]",
       :content_type => 'text/html')
  end
end
