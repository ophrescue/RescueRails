class UserMailer < ActionMailer::Base
  default from: "Operation Paws for Homes <info@ophrescue.org>" 
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "OPH Rescue Password Reset"
  end
end
