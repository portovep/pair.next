source "https://rubygems.org"

# General
gem "sinatra"

# Auth (Okta integration)
gem "sinatra-contrib"
gem "omniauth"
gem "omniauth-saml"

# Persistence
gem "activerecord"
gem "sinatra-activerecord"
gem "pg"

# Specs
group :development, :test do
  gem "rspec"
  gem "rack-test", require: "rack/test"
  gem 'nokogiri'

  # test them associations
  gem 'activemodel'
  gem 'shoulda'
  gem 'shoulda-matchers'
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
