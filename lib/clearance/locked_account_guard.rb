module Clearance
  class LockedAccountGuard < Clearance::SignInGuard
    def call
      if locked?
        failure("Your Account is Locked.  You must contact joanne@ophrescue.org to reactivate your account.")
      else
        next_guard
      end
    end

    def locked?
      return if current_user.nil?
      current_user.locked?
    end
  end
end
