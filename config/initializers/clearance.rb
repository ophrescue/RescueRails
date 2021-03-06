Clearance.configure do |config|
  config.allow_sign_up = false
  config.mailer_sender = "Operation Paws for Homes <info@ophrescue.org>"

  config.password_strategy = PasswordStrategies::WoofBark
  config.redirect_url = '/'
  config.rotate_csrf_on_sign_in = true
  config.same_site = :lax
  config.routes = false
  config.signed_cookie = true
  config.sign_in_guards = [Clearance::LockedAccountGuard,Clearance::LogLastLoginAt]

  config.cookie_expiration = ->(cookies) { 1.week.from_now if cookies['remember_me'] }
end
