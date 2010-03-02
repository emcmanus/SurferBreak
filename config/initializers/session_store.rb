# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_surferbreak_session',
  :secret      => '038b51b064894e02294c2b982a094a3b62a2f91d0fc40993a61f767c260efab9b53fd4ffc4324bd00f730409be144e75c0e3e4b7ef03355d29a61f20d696c90a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
