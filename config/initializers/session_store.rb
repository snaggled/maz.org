# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_site_session',
  :secret => 'a1e84d8b5a5074addb8c87b12940850ccd3bd37277cb98e1e7638f85dca20f3dce8b7e8335fb4cb420f273f394b86bfd1f539bfdab1d6907847ecde2f4e5ba13'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
