# This is how your config file should look.
# This is my Heroku config file.
# Heroku recommends setting environment variables on their system

case Rails.env
when "development"
  AuthlogicConnect.config = YAML.load_file("config/authlogic.yml")
when "production"
  AuthlogicConnect.config = {
    :connect => {
      :twitter => {
        :key => ENV["CONNECT_TWITTER_KEY"],
        :secret => ENV["CONNECT_TWITTER_SECRET"],
        :label => "Twitter"
      },
      :facebook => {
        :key => ENV["CONNECT_FACEBOOK_KEY"],
        :secret => ENV["CONNECT_FACEBOOK_SECRET"],
        :label => "Facebook"
      }
    }
  }
end
