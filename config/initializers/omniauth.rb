require 'openid/store/filesystem'

FACEBOOK = YAML.load_file("#{RAILS_ROOT}/config/facebook.yml")[RAILS_ENV]
ActionController::Dispatcher.middleware.use OmniAuth::Builder do
 
  provider :twitter, 'YH7ajAJOz65C8I5PVoGA', 'R57Sxk6iDsEFfROcg17syrwnwWTwmltlxQeMdB7F5qo'
#  provider :facebook, FACEBOOK['app_id'], FACEBOOK['app_secret']
  provider :facebook '149521741834368', '56c6eba1e8effa37c8e38c7d3fa6a5f7'
end

# you will be able to access the above providers by the following url
# /auth/providername for example /auth/twitter /auth/facebook

