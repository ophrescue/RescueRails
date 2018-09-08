# Preview all emails at http://localhost:3000/rails/mailers/donation_receipt
class DonationMailerPreview < ActionMailer::Preview
  def donation_receipt
    @donation = Donation.last
    DonationMailer.donation_receipt(@donation.id)
  end
end
