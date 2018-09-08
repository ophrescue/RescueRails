module Clearance
  class LogLastLoginAt < Clearance::SignInGuard
    def call
      current_user.touch(:last_login_at)
      next_guard
    end
  end
end
