# Preview all emails at http://localhost:3000/rails/mailers/donation_receipt
class AdoptAppMailerPreview < ActionMailer::Preview
  def adopt_app
    @adopter = Adopter.last
    AdoptAppMailer.adopt_app(@adopter.id)
  end
end
