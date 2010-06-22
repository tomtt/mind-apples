class UserSession < Authlogic::Session::Base
  authenticate_with Person
  generalize_credentials_error_messages true
end
