class UserSession < Authlogic::Session::Base
  authenticate_with Person
  generalize_credentials_error_messages true
  
  def self.oauth_consumer
    OAuth::Consumer.new(APP_CONFIG['connect']['twitter']['key'], APP_CONFIG['connect']['twitter']['secret'],
    { :site=>"http://twitter.com",
      :authorize_url => "http://twitter.com/oauth/authenticate" })
  end
  
end
