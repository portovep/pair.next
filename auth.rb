require 'sinatra/config_file'
require 'securerandom'
require 'openssl'
require 'base64'

require 'omniauth-openid'
require 'openid/store/filesystem'

config_file 'config.yml'

# Sessions
enable :sessions

# configure 'SECRET_TOKEN' in .env
set :session_secret, ENV['SECRET_TOKEN'] || SecureRandom.hex

OpenID.fetcher.ca_file = "#{APP_ROOT}/ca-bundle.cer"
use OmniAuth::Builder do
  provider :open_id, :identifier => 'https://www.google.com/accounts/o8/id'
end

helpers do

  def protected!
    return if authorized?
    redirect to("/auth/open_id")
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

  def current_team
    team = Team.find_by_id(params[:team_id])
    if team
      return team
    else
      redirect to '/team/new'
    end
  end

  def protect_team!
    redirect to '/team/new' unless current_user
    unless current_user.member_of?(current_team)
      session[:error_message] = "You are not a member of the team you are trying to access"
      redirect to '/team/new'
    end
  end

end

# Support both GET and POST for callbacks
post '/auth/open_id/callback' do
  auth = env['omniauth.auth']
  logger.info auth[:info]
  login!(auth[:info][:email])
  redirect to(params[:RelayState] || "/")
end
