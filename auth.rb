require 'sinatra/config_file'
require 'securerandom'
require 'openssl'
require 'base64'

require 'omniauth-google-oauth2'

config_file 'config.yml'

# Sessions
enable :sessions

# Do not push live, placeholder for later
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

# configure 'SECRET_TOKEN' in .env
set :session_secret, ENV['SECRET_TOKEN'] || SecureRandom.hex

use OmniAuth::Builder do
    provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"]
end

helpers do

  def protected!
    return if authorized?
    redirect to("/auth/google_oauth2")
  end

  def authorized?
    session[:user_id]
  end

  def login!(username)
    user = User.where(username: username).first_or_create
    session[:user_id] = user.username
  end

  def current_user
    User.find_by_username(session[:user_id])
  end

end

# Support both GET and POST for callbacks

get '/auth/google_oauth2/callback' do
  auth = env['omniauth.auth']
  logger.info auth[:info]
  login!(auth[:info][:email])
  redirect to(params[:RelayState] || "/")
end

post '/auth/google_oauth2/callback' do
  auth = env['omniauth.auth']
  logger.info auth[:info]
  login!(auth[:info][:email])
  redirect to(params[:RelayState] || "/")
end
