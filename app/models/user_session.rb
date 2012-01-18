class UserSession < Authlogic::Session::Base
  generalize_credentials_error_messages true
  find_by_login_method :find_by_login_or_email
end
