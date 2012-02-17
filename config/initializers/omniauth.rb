require 'openid/store/filesystem'

FACEBOOK = YAML.load_file("#{RAILS_ROOT}/config/facebook.yml")[RAILS_ENV]

ActionController::Dispatcher.middleware.use OmniAuth::Builder do
 
  provider :twitter, 'YH7ajAJOz65C8I5PVoGA', 'R57Sxk6iDsEFfROcg17syrwnwWTwmltlxQeMdB7F5qo'
  if RAILS_ENV == "development"
    provider :facebook, FACEBOOK['app_id'], FACEBOOK['app_secret']
  else
    provider :facebook, FACEBOOK['app_id'], FACEBOOK['app_secret'], {:scope => 'email, offline_access', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}}
end

# you will be able to access the above providers by the following url
# /auth/providername for example /auth/twitter /auth/facebook

