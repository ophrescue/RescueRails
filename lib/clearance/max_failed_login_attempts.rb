module Clearance
  class MaxFailedLoginAttemptsGuard < Clearance::SignInGuard
    def call
      if current_user.failed_login_attempts >= 3
        failure("Your Account has exceeded the maximum number of failed attempts.  You must contact joanne@ophrescue.org to reactivate your account.")
      else
        current_user.update_all(:failed_login_attempts, 0)
        next_guard
      end
    end
  end
end
