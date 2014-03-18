source "https://rubygems.org"

# General
gem "sinatra"

# Auth (Okta integration)
gem "sinatra-contrib"
gem "omniauth"
gem "omniauth-saml"

# Auth (OpenID)
gem "omniauth-openid"


# Persistence
gem "activerecord"
gem "sinatra-activerecord"
gem "pg"

# Specs
group :development, :test do
  gem "rspec"
  gem "rack-test", require: "rack/test"
  gem 'nokogiri'
end

group :development do
  # Error display
  gem "binding_of_caller"
  gem "better_errors"

  # better console
  gem "pry"

  # dev server
  gem "shotgun"

  # load env variables
  gem "dotenv"
end
