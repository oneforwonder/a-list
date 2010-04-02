# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_a-list_session',
  :secret      => '91de68456046e2ab42d6fb668d73f3d2d22f03f7008128f85a0ed116401f542fcb5dd702bf73f1ceb9ac1c0009524e08f06ce1e5b636c5b1a1de145876cbfae3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
