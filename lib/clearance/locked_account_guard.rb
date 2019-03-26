module Clearance
    class LockedAccountGuard < Clearance::SignInGuard
      def call
        if is_locked?
          failure("Your Account is Locked.  You must contact joanne@ophrescue.org to reactivate your account.")
        else
          next_guard
        end
      end

      def is_locked?
        current_user.locked?
      end
    end
  end
