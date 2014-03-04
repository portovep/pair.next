require 'bundler/setup'
Bundler.require(:default)

require 'openssl'
require 'base64'

require_relative './auth.rb'
# ActiveRecord::Base.logger = Logger.new(STDERR)
# ActiveRecord::Base.establish_connection(:adapter  => 'sqlite3', :database => 'db.sqlite')

# require "sinatra"

set :app_file, __FILE__

before do
  protected! unless request.path_info.include? '/auth'
end

get '/hi' do
  erb :index
end
