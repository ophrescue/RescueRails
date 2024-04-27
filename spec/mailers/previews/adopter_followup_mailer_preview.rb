class AdopterFollowupMailerPreview < ActionMailer::Preview
  def one_week_followup
    @adopter = Adopter.last
    AdopterFollowupMailer.one_week_followup(@adopter.id)
  end
end
