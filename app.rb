set :app_file, __FILE__

# Okta integration
before do
  request_path = request.path_info
  return if request_path.start_with? '/auth'
  return if ['/', '/hi'].include? request_path
  protected!
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
  @team.users << current_user

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

post '/team/:team_id/members' do
  @team = Team.find_by_id(params[:team_id])

  new_member = User.find_by_username(params[:member_username])
  if new_member
    unless @team.users.include?(new_member)
      @team.users << new_member
      @team.save
    else
      session[:error_message] = "#{params[:member_username]} is already a member!"
    end
  else
    session[:error_message] = "#{params[:member_username]} does not exist!"
  end
  redirect to "/team/#{@team.id}"
end


get '/team/:team_id/shuffle' do
  @team = Team.find_by_id(params[:team_id])
  @old_pairs = @team.get_old_pairs
  @new_pairs = []
  erb :shuffle_page
end

post '/team/:team_id/shuffle' do
  @team = Team.find_by_id(params[:team_id])
  @old_pairs = @team.get_old_pairs
  @new_pairs = @old_pairs
  erb :shuffle_page
end

post '/auth/saml/callback' do
  auth = request.env['omniauth.auth']
  session[:user_id] = auth[:uid]

  redirect to(params[:RelayState] || "/")
end
