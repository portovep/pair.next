set :app_file, __FILE__
# set :method_override, true

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
  if current_user
    @teams = Team.all.to_a.select { |team| team.users.include? current_user }
  end
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
  elsif !@team.users.include? current_user
    session[:error_message] = "You are not a member of the team you are trying to access"
    redirect to '/team/new'
  else
    erb :team_profile
  end
end

post '/team/:team_id/members' do
  @team = Team.find_by_id(params[:team_id])

  new_member = User.find_by_username(params[:member_username])
  if !@team.users.include? current_user
    session[:error_message] = "You are not a member of the team you are trying to access"
    redirect to '/team/new'
  elsif new_member
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
  @old_pairs = @team.get_current_pairs
  @new_pairs = []
  erb :shuffle_page
end

post '/team/:team_id/shuffle' do
  @team = Team.find_by_id(params[:team_id])
  @old_pairs = @team.get_current_pairs
  @new_pairs = @team.shuffle_pairs
  erb :shuffle_page
end

post '/team/:team_id/savePairs' do

  # convertig pairs into better format:
  input_data = params['pair']
  pairs = []
  input_data[0].values.each do |pairData|
    pair = []
    pairData.values.each do |userData|
      pair << userData
    end
    pairs << pair
  end

  @team = Team.find_by_id(params[:team_id]).end_current_pairing_sessions

  pairs.each do |pair|
    pairing_session = PairingSession.create(start_time: Time.now, end_time: nil)
    pair.each do |member|
      pairing_session.users << User.find_by_id(member)
    end
  end

  redirect to "/team/#{params[:team_id]}/shuffle"
end

delete '/team/:team_id/user/:user_id' do 
  team = Team.find_by_id(params[:team_id])
  user = User.find_by_id(params[:user_id])
  session[:success_message] =  "User removed from team."

  team.users.delete(user)

  redirect to "/team/#{team.id}"
end

get '/team/:team_id/history' do 
  team = Team.find_by_id(params[:team_id])
  @team = team
  @history = team.pairing_history
  @statistics = team.pairing_statistics
  erb :history
end

get '/user' do 
  @user = User.find_by_id(params[:user_id])
  if (!(current_user))
    session[:error_message] =  "You are not logged in."
    redirect to '/team/new'
  else
    redirect to '/user/' + current_user.id.to_s  
  end
  

end

get '/user/:user_id' do
  @user = User.find_by_id(params[:user_id])
  if @user.nil?
    session[:error_message] =  "You are not logged in."
    redirect to '/hi'
  elsif @user.id != current_user.id
    redirect to '/user/' + current_user.id.to_s
  else
    @teams = Team.all.to_a.select { |team| team.users.include? current_user }
    erb :user_page
  end

end