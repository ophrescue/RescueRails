# Rails 7.0 removed the classic autoloader fallback that let initializers
# reference custom lib/ constants directly at boot. Deferring to to_prepare
# runs this after the Zeitwerk autoloader is set up, per Rails' own upgrade guidance.
Rails.application.reloader.to_prepare do
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
end
