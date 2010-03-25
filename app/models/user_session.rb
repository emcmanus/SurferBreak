class UserSession < Authlogic::Session::Base
  consecutive_failed_logins_limit 30    # See Authlogic::Session::BruteForceProtection
end