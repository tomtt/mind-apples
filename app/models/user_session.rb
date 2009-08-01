class UserSession < Authlogic::Session::Base
  authenticate_with Person
end
