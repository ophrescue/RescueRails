class NewAdopterMailerPreview < ActionMailer::Preview
  def adopter_created
    @adopter = Adopter.last
    NewAdopterMailer.adopter_created(@adopter.id)
  end
end
