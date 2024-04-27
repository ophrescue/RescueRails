class TrainingMailerPreview < ActionMailer::Preview
  def free_training_notice
    @adopter = Adopter.last
    TrainingMailer.free_training_notice(@adopter.id)
  end
end
