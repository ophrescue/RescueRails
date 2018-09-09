module Clearance
  class LogLastLoginAt < Clearance::SignInGuard
    def call
      current_user&.touch(:lastlogin)
      next_guard
    end
  end
end
