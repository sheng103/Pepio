# Be sure to restart your server when you modify this file.
#REALP B
  #ActionDispatch::Session::CookieStore,
  #ActiveRecord::SessionStore,
Rails.application.config.middleware.insert_before(
  ActionDispatch::Cookies,
  FlashSessionCookieMiddleware,
  Rails.application.config.session_options[:key]
)
#REALP E

#Smmoney::Application.config.session_store :cookie_store, :key => '_smmoney_session'
Smmoney::Application.config.session_store :active_record_store

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Smmoney::Application.config.session_store :active_record_store
