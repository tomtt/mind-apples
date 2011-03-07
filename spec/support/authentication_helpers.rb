require 'authlogic/test_case'

def login_as(user)
  activate_authlogic
  UserSession.create(user)
end
