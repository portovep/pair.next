set :app_file, __FILE__

# Okta integration
before do
  #protected! unless request.path_info.start_with? '/auth'
end

get '/' do
  redirect to '/hi'
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
    redirect to "/team/#{@team.id}"
  else
    erb :team_setup
  end

end

get '/team/:team_id' do
  @team = Team.find_by_id(params[:team_id])
  if @team.nil?
    session[:error_message] =  "Team not found"
    redirect to '/team/new'
  else
    erb :team_profile
  end
end

get '/team/:team_id/shuffle' do
  @team = Team.find_by_id(params[:team_id])
  erb :shuffle_page
end