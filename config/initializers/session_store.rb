# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_site_session',
  :secret      => '77f2165658e5f53167f4072fbcf115b604ae35931fbb636c0d37fd0111385dc5b603774f3d33d4c96fef09398e57d28248bb70d0e93d6c9e769c81de6c63104e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
