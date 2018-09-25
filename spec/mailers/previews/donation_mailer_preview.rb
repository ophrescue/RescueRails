# Preview all emails at http://localhost:3000/rails/mailers/donation_receipt
class DonationMailerPreview < ActionMailer::Preview
  def donation_receipt
    @donation = Donation.last
    DonationMailer.donation_receipt(@donation.id)
  end

  def donation_notification
    @donation = Donation.where(notify_someone: true).last
    DonationMailer.donation_notification(@donation.id)
  end

  def donation_accounting_notification
    @donation = Donation.first
    DonationMailer.donation_accounting_notification(@donation.id)
  end
end
