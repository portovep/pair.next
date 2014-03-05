require 'sinatra'
require 'sinatra/contrib'
require_relative './auth.rb'
require_relative './db.rb'
require_relative './models/user.rb'
require_relative './models/team.rb'
require_relative './models/team_member.rb'
require_relative './models/pairing_session.rb'
require_relative './models/pairing_membership.rb'
APP_ROOT = Pathname.new(File.expand_path('../', __FILE__))

require 'bundler/setup'
Bundler.require(:default)

# Better Errors error handling
require "better_errors"
require "binding_of_caller"
configure :development do
	use BetterErrors::Middleware
	BetterErrors.application_root = __dir__
end

# Security
require 'openssl'
require 'base64'

require_relative './auth.rb'

register Sinatra::Contrib

set :app_file, __FILE__

# Okta integration
before do
  protected! unless request.path_info.start_with? '/auth'
end

get '/hi' do
	erb :index
end

get '/team/new' do
  erb :team_setup
end

post '/team/new' do
  session[:success_message] =  "Team successfully created"
  erb :team_profile
end
