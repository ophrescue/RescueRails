# Preview all emails at http://localhost:3000/rails/mailers/adopt_app_mailer
class AdoptAppMailerPreview < ActionMailer::Preview
  def adopt_app
    @adopter = Adopter.last
    AdoptAppMailer.adopt_app(@adopter.id)
  end

  def approved_to_adopt
    @adopter = Adopter.last
    AdoptAppMailer.approved_to_adopt(@adopter.id)
  end
end
