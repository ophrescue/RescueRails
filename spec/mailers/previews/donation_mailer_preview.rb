# Preview all emails at http://localhost:3000/rails/mailers/donation_mailer
class DonationMailerPreview < ActionMailer::Preview
  def donation_mailer
    @donation = Donation.last
    DonationMailer.donation_mailer(@donation.id)
  end
end
