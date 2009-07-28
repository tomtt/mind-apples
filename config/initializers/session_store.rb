# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mindapples_session',
  :secret      => '35eb4a3280392a06d4c3f7205b4f15746ee75400c8de1579e91bd88fc12149fb8d5cc005a2e14b4d89427c6c8c4d5fc190a15bc0b9e83aad43e223aa60a01994'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
