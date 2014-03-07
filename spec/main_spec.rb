require_relative './test_helper.rb'

describe 'Main' do

  context 'with a signed in user' do

    let(:session) do
      { 'rack.session' => { user_id: 'valid_id' } }
    end

    it 'should say welcome' do
      get '/hi', {}, session
      expect(last_response.body).to include("Welcome to Pair.Next")
    end

    it 'should list user team membership when user is logged in' do
      team = Team.create(name: 'team_test')
      team2 = Team.create(name: 'team_test2')
      user = User.create(username: 'valid_id')
      team.users << user
      team2.users << user

      get '/hi', {}, session

      expect(last_response.body).to include(team.name)
      expect(last_response.body).to include(team2.name)
    end

    it 'should not list user team membership when user is not member of a team' do
      user = User.create(username: 'valid_id')

      get '/hi', {}, session

      expect(last_response.body).to_not include('Your teams')
    end

  end

end
