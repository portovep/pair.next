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
