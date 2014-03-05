set :app_file, __FILE__

# Okta integration
before do
  #protected! unless request.path_info.start_with? '/auth'
end

get '/hi' do
	erb :index
end

get '/team/new' do
  @team = Team.new
  erb :team_setup
end

post '/team/new' do
  @team = Team.new(name: params[:team_name])

  if @team.save
    session[:success_message] =  "Team #{@team.name} successfully created"
    erb :team_profile 
  else
    erb :team_setup
  end

end

