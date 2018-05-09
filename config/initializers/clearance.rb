Clearance.configure do |config|
  config.allow_sign_up = false
  config.mailer_sender = "admin@ophrescue.org"
  config.password_strategy = PasswordStrategies::WoofBark
  config.sign_in_guards = []
  config.rotate_csrf_on_sign_in = true
end
