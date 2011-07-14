class UserSession < Authlogic::Session::Base
  authenticate_with Person
  generalize_credentials_error_messages true
  
  # def self.oauth_consumer
  #   OAuth::Consumer.new(
  #     "YH7ajAJOz65C8I5PVoGA", "R57Sxk6iDsEFfROcg17syrwnwWTwmltlxQeMdB7F5qo",
  #     {
  #       :site => "http://api.twitter.com",
  #       :authorize_url => "https://api.twitter.com/oauth/authorize"
  #     }
  #   )
  # end
end
