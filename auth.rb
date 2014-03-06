require 'sinatra/config_file'
require 'securerandom'
require 'openssl'
require 'base64'

config_file 'config.yml'

# Sessions
enable :sessions
# configure 'SECRET_TOKEN' in .env
Dotenv.load
set :session_secret, ENV['SECRET_TOKEN'] || SecureRandom.hex

use OmniAuth::Builder do
  provider :saml,
  :issuer                             => settings.auth['issuer'],
  :idp_sso_target_url                 => settings.auth['target_url'],
  :idp_cert_fingerprint               => settings.auth['fingerprint'],
  :name_identifier_format             => "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress",
  :idp_sso_target_url_runtime_params  => {:redirectUrl => :RelayState}
end

set :protection, :origin_whitelist => ['https://thoughtworks.okta.com']

helpers do

  def protected!
    return if authorized?
    redirect to("/auth/saml?redirectUrl=#{URI::encode(request.path)}")
  end

  def authorized?
    session[:user_id]
  end

end
