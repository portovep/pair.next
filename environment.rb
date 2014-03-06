require 'bundler/setup'
Bundler.require(:default)

if development? || test?
  Bundler.require(:development, :test)
  Dotenv.load # load environment variables from .env
end

APP_ROOT = Pathname.new(File.expand_path('../', __FILE__))

require_relative './db.rb'
require_relative './auth.rb'
require_relative './app.rb'

Dir['./models/*.rb'].each { |model| require_relative model }

# Better Errors error handling
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

register Sinatra::Contrib
