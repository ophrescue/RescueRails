class BitePreventionMailerPreview < ActionMailer::Preview
  def bite_prevent
    @adopter = Adopter.last
    BitePreventionMailer.bite_prevent(@adopter.id)
  end
end
